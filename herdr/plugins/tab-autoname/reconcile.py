#!/usr/bin/env python3
"""Full naming pass for tab-autoname.

Runs for herdr plugin events, startup, and the plugin actions. The zsh hooks
autoname.sh handles per-command renames; this script keeps the whole session
consistent after pane/tab lifecycle and focus changes, and detects manual
renames.

Policy:
  * A tab is named after the foreground process of its focused pane (or its
    first pane while the tab is in a background workspace) - "sleep", "nvim",
    "node"; at the prompt the foreground process is the shell itself, so the
    tab is named "zsh". This mirrors tmux's automatic-rename.
  * Hand renames win: once the plugin has named a tab, any label it did not
    set marks the tab manual, and it is left alone until `adopt` clears the
    marker (or the tab closes).
"""

import json
import os
import re
import shutil
import subprocess
import sys
import time

HERDR_BIN = os.environ.get("HERDR_BIN_PATH", "herdr")
SOCKET_PATH = os.environ.get(
    "HERDR_SOCKET_PATH",
    os.path.join(os.path.expanduser("~"), ".config", "herdr", "herdr.sock"),
)

if os.path.basename(os.path.dirname(os.path.dirname(SOCKET_PATH))) == "sessions":
    SESSION_KEY = os.path.basename(os.path.dirname(SOCKET_PATH))
else:
    SESSION_KEY = "default"

STATE_ROOT = os.environ.get("TAB_AUTONAME_STATE") or os.path.join(
    os.path.expanduser("~"), ".local", "state", "herdr-tab-autoname"
)
STATE_DIR = os.path.join(STATE_ROOT, SESSION_KEY)
OWNED_DIR = os.path.join(STATE_DIR, "owned")
MANUAL_DIR = os.path.join(STATE_DIR, "manual")
LOCK_DIR = os.path.join(STATE_DIR, "lock")

CONTROL_CHARS = re.compile(r"[\x00-\x1f\x7f]")


def run_herdr(*args):
    """Run the herdr CLI; return parsed JSON or None on any failure."""
    try:
        out = subprocess.run(
            [HERDR_BIN] + list(args),
            capture_output=True,
            text=True,
            timeout=10,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    if out.returncode != 0:
        return None
    try:
        return json.loads(out.stdout)
    except ValueError:
        return None


def herdr_result(*args):
    data = run_herdr(*args)
    if isinstance(data, dict):
        return data.get("result", data)
    return None


def acquire_lock(timeout_ms):
    deadline = time.time() + timeout_ms / 1000.0
    while True:
        os.makedirs(os.path.dirname(LOCK_DIR), exist_ok=True)
        try:
            os.mkdir(LOCK_DIR)
            return True
        except FileExistsError:
            try:
                if time.time() - os.path.getmtime(LOCK_DIR) > 60:
                    shutil.rmtree(LOCK_DIR, ignore_errors=True)
                    continue
            except OSError:
                continue
            if time.time() >= deadline:
                return False
            time.sleep(0.05)
        except OSError:
            return False


def release_lock():
    shutil.rmtree(LOCK_DIR, ignore_errors=True)


def owned_get(tab_id):
    try:
        with open(os.path.join(OWNED_DIR, tab_id)) as fh:
            return fh.read().strip()
    except OSError:
        return ""


def owned_set(tab_id, label):
    os.makedirs(OWNED_DIR, exist_ok=True)
    with open(os.path.join(OWNED_DIR, tab_id), "w") as fh:
        fh.write(label + "\n")


def is_manual(tab_id):
    return os.path.exists(os.path.join(MANUAL_DIR, tab_id))


def mark_manual(tab_id, reason):
    os.makedirs(MANUAL_DIR, exist_ok=True)
    with open(os.path.join(MANUAL_DIR, tab_id), "w") as fh:
        fh.write(reason + "\n")


def clear_manual(tab_id):
    try:
        os.remove(os.path.join(MANUAL_DIR, tab_id))
    except OSError:
        pass


def snapshot():
    result = herdr_result("api", "snapshot")
    if result is None:
        return None
    return result.get("snapshot")


def process_name(pane_id):
    """Foreground process name of a pane: "sleep", "nvim", or the shell."""
    result = herdr_result("pane", "process-info", "--pane", pane_id)
    if result is None:
        return None
    info = result.get("process_info") or {}
    procs = info.get("foreground_processes") or []
    if not procs:
        return None
    fg_pgid = info.get("foreground_process_group_id")
    proc = None
    for candidate in procs:
        if candidate.get("pid") == fg_pgid:
            proc = candidate
            break
    if proc is None:
        proc = procs[-1]
    name = proc.get("name") or proc.get("argv0") or ""
    name = CONTROL_CHARS.sub("", os.path.basename(name)).strip()
    return name or None


def pane_order(pane):
    match = re.search(r":p(\d+)$", pane.get("pane_id", ""))
    return int(match.group(1)) if match else 0


def naming_pane(panes_of_tab):
    """The pane a tab is named after: the focused one, else the first."""
    if not panes_of_tab:
        return None
    for pane in panes_of_tab:
        if pane.get("focused"):
            return pane
    return panes_of_tab[0]


def prune_state(tab_ids):
    """Drop bookkeeping for tabs the session no longer has."""
    for directory in (OWNED_DIR, MANUAL_DIR):
        try:
            names = os.listdir(directory)
        except OSError:
            continue
        for name in names:
            if name not in tab_ids:
                try:
                    os.remove(os.path.join(directory, name))
                except OSError:
                    pass


def event_tabs(tabs, panes):
    event_name = os.environ.get("HERDR_PLUGIN_EVENT", "")
    if event_name not in ("tab.created", "tab.focused", "pane.created", "pane.focused"):
        return tabs
    try:
        event = json.loads(os.environ.get("HERDR_PLUGIN_EVENT_JSON", ""))
    except ValueError:
        return tabs
    if not isinstance(event, dict) or not isinstance(event.get("data"), dict):
        return tabs
    data = event["data"]
    if event_name == "tab.created":
        tab_id = (data.get("tab") or {}).get("tab_id")
    elif event_name == "tab.focused":
        tab_id = data.get("tab_id")
    elif event_name == "pane.created":
        tab_id = (data.get("pane") or {}).get("tab_id")
    else:
        tab_id = next(
            (pane.get("tab_id") for pane in panes if pane.get("pane_id") == data.get("pane_id")),
            None,
        )
    if not tab_id:
        return tabs
    return [tab for tab in tabs if tab.get("tab_id") == tab_id]


def full_pass(reason):
    if not acquire_lock(2000):
        print("tab-autoname: lock busy, skipping (%s)" % reason)
        return 0
    try:
        snap = snapshot()
        if snap is None:
            return 0
        tabs = snap.get("tabs") or []
        panes = snap.get("panes") or []
        prune_state({t.get("tab_id") for t in tabs})
        if reason not in ("startup", "adopt"):
            tabs = event_tabs(tabs, panes)

        panes_by_tab = {}
        for pane in panes:
            panes_by_tab.setdefault(pane.get("tab_id"), []).append(pane)

        for tab in tabs:
            tab_id = tab.get("tab_id")
            label = tab.get("label", "")
            if not tab_id or is_manual(tab_id):
                continue
            candidates = sorted(panes_by_tab.get(tab_id, []), key=pane_order)
            pane = naming_pane(candidates)
            if pane is None:
                continue
            target = process_name(pane["pane_id"])
            if not target:
                continue
            if target == label:
                if owned_get(tab_id) != target:
                    owned_set(tab_id, target)
                continue
            if herdr_result("tab", "rename", tab_id, target) is not None:
                owned_set(tab_id, target)
        return 0
    finally:
        release_lock()


def on_renamed():
    """A tab.renamed event fired: ours, or a hand rename to respect."""
    raw = os.environ.get("HERDR_PLUGIN_EVENT_JSON", "")
    try:
        event = json.loads(raw)
    except ValueError:
        return 0
    data = event.get("data", event)
    tab_id = data.get("tab_id")
    label = data.get("label")
    if not tab_id or label is None:
        return 0

    # Our own renames fire this event too. The fast path writes the owned
    # record immediately after the rename lands, so a mismatch can simply be
    # that write not being visible yet; give it a few beats before concluding
    # that a person renamed the tab.
    for _ in range(6):
        if owned_get(tab_id) == label:
            return 0
        time.sleep(0.05)

    if is_manual(tab_id):
        return 0
    mark_manual(tab_id, label)
    print("tab-autoname: manual rename %s -> %r, leaving it alone" % (tab_id, label))
    return 0


def focused_tab_id():
    tab_id = os.environ.get("HERDR_TAB_ID")
    if tab_id:
        return tab_id
    snap = snapshot() or {}
    return snap.get("focused_tab_id")


def main(argv):
    command = argv[1] if len(argv) > 1 else ""
    reason = argv[2] if len(argv) > 2 else command

    if command == "startup":
        return full_pass("startup")
    if command == "reconcile":
        return full_pass(reason or "event")
    if command == "renamed":
        return on_renamed()
    if command == "adopt":
        tab_id = focused_tab_id()
        if not tab_id:
            print("tab-autoname: no focused tab to adopt")
            return 0
        clear_manual(tab_id)
        print("tab-autoname: adopted %s" % tab_id)
        return full_pass("adopt")
    if command == "release":
        tab_id = focused_tab_id()
        if not tab_id:
            print("tab-autoname: no focused tab to release")
            return 0
        mark_manual(tab_id, "released")
        print("tab-autoname: %s stays as named until adopted" % tab_id)
        return 0
    if command == "doctor":
        return doctor()
    print("tab-autoname: unknown command %r" % command, file=sys.stderr)
    return 2


def doctor():
    tab_id = focused_tab_id()
    if not tab_id:
        print("tab-autoname: no focused tab")
        return 0
    snap = snapshot() or {}
    label = ""
    for tab in snap.get("tabs") or []:
        if tab.get("tab_id") == tab_id:
            label = tab.get("label", "")
    panes = [p for p in (snap.get("panes") or []) if p.get("tab_id") == tab_id]
    pane = naming_pane(sorted(panes, key=pane_order))
    target = process_name(pane["pane_id"]) if pane else None
    print("tab:      %s" % tab_id)
    print("label:    %r" % label)
    print("owned:    %r" % owned_get(tab_id))
    print("manual:   %s" % ("yes" if is_manual(tab_id) else "no"))
    print("pane:     %s" % (pane.get("pane_id") if pane else "none"))
    print("foreground: %r" % target)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
