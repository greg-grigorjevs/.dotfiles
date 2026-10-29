import json
import os
import unittest
from unittest.mock import patch

import reconcile


class ReconcileTests(unittest.TestCase):
    def setUp(self):
        self.tabs = [{"tab_id": "t%d" % i, "label": "zsh"} for i in range(26)]
        self.panes = [
            {"pane_id": "p%d" % i, "tab_id": tab["tab_id"], "focused": True}
            for i, tab in enumerate(self.tabs)
        ]

    def run_pass(self, event_name, data, reason="reconcile", manual=False):
        with (
            patch.dict(os.environ, {
                "HERDR_PLUGIN_EVENT": event_name,
                "HERDR_PLUGIN_EVENT_JSON": json.dumps({"data": data}),
            }),
            patch.object(reconcile, "acquire_lock", return_value=True),
            patch.object(reconcile, "release_lock"),
            patch.object(reconcile, "snapshot", return_value={
                "tabs": self.tabs, "panes": self.panes,
            }),
            patch.object(reconcile, "prune_state") as prune,
            patch.object(reconcile, "is_manual", return_value=manual),
            patch.object(reconcile, "owned_get", return_value="zsh"),
            patch.object(reconcile, "process_name", return_value="zsh") as process,
        ):
            self.assertEqual(reconcile.full_pass(reason), 0)
            prune.assert_called_once_with({tab["tab_id"] for tab in self.tabs})
            return [call.args[0] for call in process.call_args_list]

    def test_creation_and_focus_only_inspect_affected_tab(self):
        for event, data in [
            ("tab.created", {"tab": self.tabs[7]}),
            ("tab.focused", {"tab_id": "t7"}),
            ("pane.created", {"pane": self.panes[7]}),
            ("pane.focused", {"pane_id": "p7"}),
        ]:
            with self.subTest(event=event):
                self.assertEqual(self.run_pass(event, data), ["p7"])

    def test_startup_still_inspects_all_tabs(self):
        self.assertEqual(len(self.run_pass("startup", {}, reason="startup")), 26)

    def test_unknown_or_incomplete_events_keep_full_pass(self):
        for event in ("pane.moved", "pane.closed", "tab.created"):
            with self.subTest(event=event):
                self.assertEqual(len(self.run_pass(event, {})), 26)

    def test_manual_names_are_not_changed(self):
        self.assertEqual(self.run_pass("tab.created", {"tab": self.tabs[7]}, manual=True), [])


if __name__ == "__main__":
    unittest.main()
