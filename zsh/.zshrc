# Homebrew environment without launching brew on every shell startup.
# PATH is set below with the other executable paths.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
if [[ -n ${MANPATH:-} ]]; then
  export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"
  export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"
fi
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8
export EDITOR='nvim'

# custom bindings
bindkey -s ^f "tmux_sessionizer\n"
_fzf_nvim() {
  local file
  file=$(find . -type f | fzf) || return
  [[ -n "$file" ]] && nvim -- "$file"
}
zle -N _fzf_nvim
bindkey '^[f' _fzf_nvim
bindkey '^[[1;3C' forward-word

# Aliases
alias zshconf="nvim ~/.zshrc"
alias vimconf="nvim ~/.config/nvim"
alias kittyconfig="nvim ~/.config/kitty/kitty.conf"
alias reload="source ~/.zshrc"
alias tmuxconf="nvim ~/.tmux.conf"
alias c="clear"
alias v="nvim"
alias lg="lazygit"
alias op="opencode"
alias pa="php artisan"
alias pat="php artisan test"
alias patf="php artisan test --filter"
alias dotfiles="cd ~/.dotfiles && nvim . -c 'lua require(\"fff\").find_files()'"
alias copyhistory="fc -ln 0 | fzf --tac --no-sort | tr -d \\\n | pbcopy"
alias kanataon="tmux new-session -ds kanata 'sudo /opt/homebrew/bin/kanata --cfg ~/.dotfiles/kmonad/kanata.kbd'"
alias kanataoff="tmux kill-session -t kanata"
# alias kanataon="sudo launchctl start org.nixos.kanata"
# alias kanataoff="sudo launchctl stop org.nixos.kanata"
alias kanatacheck="kanata --cfg ~/.dotfiles/kmonad/kanata.kbd --check"

alias kanatarestart="kanataoff && kanataon"
alias nixrebuild="sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles/nix#default --impure"

# Functions
gswf() {
    # use git branch --all to dislay all branches
    git switch "$(git branch  | fzf --tac | tr -d '[:space:]')"
}

#Create directory/ies and cd into it in one command
mkcd() {
    mkdir -p "$1" && cd "$1"
}

jvac() {
    javac $1.java && java $1 ;
}

pal() {
  selected_command=$(pa list --raw | awk '{print $1}' | fzf)
  print -z -- "pa $selected_command"
}

# wrapper around yazi. use this to change the cwd on exit
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function tcd() {
  if (( $# != 1 )); then
    print -u2 'Usage: tcd <directory>'
    return 2
  fi

  local path name
  path=$(realpath -- "$1") || return
  if [[ ! -d $path ]]; then
    print -u2 "tcd: not a directory: $1"
    return 1
  fi

  name=${path:t}
  # Dots in tmux target names are interpreted as window/pane separators.
  name=${name//./_}

  if ! tmux has-session -t "=$name" 2>/dev/null; then
    tmux new-session -d -s "$name" -c "$path" || return
  fi

  if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -t "=$name"
  else
    tmux attach-session -t "=$name"
  fi
}

# PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin":$PATH
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/Applications/kitty.app/Contents/MacOS":$PATH # makes kitty command work
export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/bin":$PATH
export PATH="$HOME/.composer/vendor/bin":$PATH
export PATH="$HOME/.config/composer/vendor/bin":$PATH
export PATH="$HOME/.dotfiles/bin":$PATH
export PATH="$HOME/.cargo/bin":$PATH

# lazygit
export XDG_CONFIG_HOME="$HOME/.config"

# fzf config
export FZF_DEFAULT_COMMAND="fd --exclude 'node_modules'"
export FZF_CTRL_T_COMMAND="fd -t f -I -E 'node_modules' -E 'vendor' . ."
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"


# Herd injected PHP binary.
export PATH="/Users/mbp-greg/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/mbp-greg/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/mbp-greg/Library/Application Support/Herd/config/php/74/"


export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# bun completions
[ -s "/Users/gregg/.bun/_bun" ] && source "/Users/gregg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# herdr tab auto-naming (see ~/.dotfiles/herdr/plugins/tab-autoname).
# Names the current tab after the running command, tmux-style.
[[ -n ${HERDR_PANE_ID:-} ]] && source "$HOME/.dotfiles/herdr/plugins/tab-autoname/hook.zsh"
