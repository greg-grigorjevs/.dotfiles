# tab-autoname: live per-command tab naming for herdr panes (zsh).
#
# herdr has no "foreground command changed" event, so this hook is what makes
# names update the moment a command starts or a prompt returns. The plugin's
# herdr [[events]] (see herdr-plugin.toml) reconcile everything else: focus
# changes, new/closed panes and tabs, restarts.
#
# Source this from ~/.zshrc. No-op outside herdr and when the engine is not
# next to this file. The engine run is synchronous and cheap (one state-file
# read plus at most one herdr CLI call) so ordering is guaranteed: preexec
# always lands before the command, precmd after it.

if [[ -n ${HERDR_PANE_ID:-} && -n ${HERDR_TAB_ID:-} ]]; then
  _tan_self="${(%):-%N}"
  _tan_bin="${_tan_self:A:h}/autoname.sh"
  unset _tan_self

  if [[ -x $_tan_bin ]]; then
    # $1 is the typed line, $2 the alias-expanded one; prefer $2 so `ll`-style
    # aliases name by the real program. Leading VAR=value assignments are
    # dropped. Only external commands (whence -w: command or hashed) rename
    # the tab: builtins, functions, and typos are leave the name as the shell,
    # matching the foreground process tmux would see.
    _tan_preexec() {
      local line="${2:-$1}"
      local -a words
      words=("${(@Q)${(z)line}}")
      while (( ${#words} )) && [[ ${words[1]} == [A-Za-z_][A-Za-z0-9_]*=* ]]; do
        shift words
      done
      local word=${words[1]:-}
      [[ -n $word ]] || return 0
      local kind
      if [[ $word == */* ]]; then
        kind=command            # an explicit path is always the real program
      else
        kind=$(builtin whence -w -- "$word" 2>/dev/null)
      fi
      case "${kind##*: }" in
        command|hashed) "$_tan_bin" preexec "${word:t}" ;;
        *) return 0 ;;
      esac
    }

    # Back at the prompt the foreground process is the shell itself; name the
    # tab after it, exactly like tmux shows "zsh" for an idle window.
    _tan_precmd() { "$_tan_bin" precmd "${SHELL##*/}" }

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _tan_preexec
    add-zsh-hook precmd  _tan_precmd
  fi
fi
