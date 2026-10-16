#!/usr/bin/env bash
# tab-autoname engine.
#
# Hot path: the zsh hooks (hook.zsh) call `autoname.sh preexec <name>` before a
# command runs and `autoname.sh precmd <shell>` before each prompt. Those run
# synchronously (a few ms: one state file plus one herdr CLI call) so ordering
# between a command starting and finishing is guaranteed.
#
# Everything else (herdr events, startup, actions) delegates to reconcile.py,
# which does a full idempotent pass over the session snapshot.

set -u

SELF_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)
HERDR_BIN=${HERDR_BIN_PATH:-herdr}
SOCKET_PATH=${HERDR_SOCKET_PATH:-$HOME/.config/herdr/herdr.sock}
STATE_ROOT=${TAB_AUTONAME_STATE:-$HOME/.local/state/herdr-tab-autoname}

# Default session socket lives at <config-dir>/herdr.sock; named sessions at
# <config-dir>/sessions/<name>/herdr.sock. Keep the state keyed per session so
# two sessions never share "owned" bookkeeping.
case $(dirname "$SOCKET_PATH") in
  */sessions/*) SESSION_KEY=$(basename "$(dirname "$SOCKET_PATH")") ;;
  *)            SESSION_KEY=default ;;
esac

STATE_DIR=$STATE_ROOT/$SESSION_KEY
OWNED_DIR=$STATE_DIR/owned
MANUAL_DIR=$STATE_DIR/manual
LOCK_DIR=$STATE_DIR/lock

# mkdir is the atomic primitive both processes can share; a lock older than a
# minute is treated as a crashed pass and stolen.
lock_acquire() {
  local deadline_ms=$1 waited=0
  while ! mkdir "$LOCK_DIR" 2>/dev/null; do
    if [ ! -e "$LOCK_DIR" ]; then
      continue
    fi
    if [ -z "$(find "$LOCK_DIR" -maxdepth 0 -mmin -1 2>/dev/null)" ]; then
      rm -rf "$LOCK_DIR"
      continue
    fi
    [ "$waited" -ge "$deadline_ms" ] && return 1
    sleep 0.05
    waited=$((waited + 50))
  done
  return 0
}

lock_release() { rm -rf "$LOCK_DIR"; }

fast_rename() {
  # Rename the calling tab to $1 unless a manual rename owns it or it already
  # carries the name. Never blocks longer than the lock wait.
  local tab=${HERDR_TAB_ID:-} target=$1 had_lock=0 current=
  [ -n "$tab" ] && [ -n "$target" ] || return 0
  mkdir -p "$OWNED_DIR" "$MANUAL_DIR"
  [ -e "$MANUAL_DIR/$tab" ] && return 0

  [ -f "$OWNED_DIR/$tab" ] && IFS= read -r current < "$OWNED_DIR/$tab"
  [ "$current" = "$target" ] && return 0

  lock_acquire 300 && had_lock=1

  # Re-check under the lock: a reconcile may have settled the tab meanwhile.
  [ -e "$MANUAL_DIR/$tab" ] && { [ "$had_lock" = 1 ] && lock_release; return 0; }
  current=
  [ -f "$OWNED_DIR/$tab" ] && IFS= read -r current < "$OWNED_DIR/$tab"
  if [ "$current" != "$target" ]; then
    if "$HERDR_BIN" tab rename "$tab" "$target" >/dev/null 2>&1; then
      printf '%s\n' "$target" > "$OWNED_DIR/$tab"
    fi
  fi
  [ "$had_lock" = 1 ] && lock_release
  return 0
}

cmd=${1:-}
shift 2>/dev/null || true

case $cmd in
  preexec|precmd)
    fast_rename "${1:-}"
    ;;
  reconcile|startup|renamed|adopt|release|doctor)
    exec python3 "$SELF_DIR/reconcile.py" "$cmd" "${1:-}"
    ;;
  *)
    echo "usage: autoname.sh preexec <name> | precmd <shell> | reconcile | renamed | adopt | release | doctor" >&2
    exit 2
    ;;
esac
