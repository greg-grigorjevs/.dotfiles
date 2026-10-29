# tab-autoname

A personal herdr plugin: name tabs after the foreground command of the tab's
focused pane, like tmux's `automatic-rename`. A tab running `nvim` shows
`nvim`; at a prompt it shows the shell name (`zsh`); a long build in a split
pane names the tab when that pane is focused.

## How it works

herdr fires no event when a foreground command changes (verified against
0.9.5: `pane.updated` only covers terminal-title changes), so the plugin has
two halves:

- `hook.zsh` - sourced from `~/.zshrc`. On every command (`preexec`) it calls
  `autoname.sh preexec <name>`; on every prompt (`precmd`) `... precmd <shell>`.
  The engine run is synchronous and cheap (one state file read plus at most one
  herdr CLI call, ~5 ms), so a command's start always lands before its finish.
  Only external commands rename the tab: builtins, functions, and typos leave
  the shell name, matching the foreground process tmux would see.
- `herdr-plugin.toml` events + `reconcile.py` - creation and focus events check
  only the affected tab. Startup, closure, and move events run a full pass. For tabs
  whose panes are not running the hook (another shell, a restored session), the
  pass reads `pane process-info` and names the tab from the foreground process.

## Renaming a tab by hand

Once the plugin has named a tab, a label it did not set is treated as a hand
rename: the tab is left alone until you adopt it again. Inside herdr:

```sh
herdr plugin action invoke tab-autoname.adopt    # resume auto-naming this tab
herdr plugin action invoke tab-autoname.release  # stop naming this tab
herdr plugin action invoke tab-autoname.doctor   # explain the current name
```

Or bind keys in `~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "prefix+shift+a"
type = "plugin_action"
command = "tab-autoname.adopt"
description = "re-adopt tab auto-naming"
```

## Install

```sh
herdr plugin link ~/.dotfiles/herdr/plugins/tab-autoname
```

and add to `~/.zshrc`:

```zsh
[[ -n ${HERDR_PANE_ID:-} ]] && source "$HOME/.dotfiles/herdr/plugins/tab-autoname/hook.zsh"
```

New panes pick the hook up automatically; existing shells need a re-source
(`source ~/.zshrc`) or a herdr restart.

## Uninstall

```sh
herdr plugin unlink tab-autoname
rm -rf ~/.local/state/herdr-tab-autoname
```

Remove the `hook.zsh` line from `~/.zshrc`. Tab names that were set stay until
renamed.

## Notes and limits

- State lives in `~/.local/state/herdr-tab-autoname/<session>/` (`owned/` is
  the last label the plugin set per tab, `manual/` marks hand renames).
  `TAB_AUTONAME_STATE` overrides the root.
- Panes that do not run the zsh hook (bash, remote shells) are named on the
  next event that triggers a pass - focus, pane/tab lifecycle - not per
  command.
- A tab with several panes is named after its focused pane, or its first pane
  while its workspace is in the background.
- Workspace labels are not touched; herdr still tracks them from the cwd.
