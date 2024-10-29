eval "$(/opt/homebrew/bin/brew shellenv)"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8
export EDITOR='nvim'

# custom bindings
bindkey -s ^f "tmux_sessionizer\n"

# Aliases
alias zshconf="nvim ~/.zshrc"
alias vimconf="nvim ~/.config/nvim"
alias kittyconfig="nvim ~/.config/kitty/kitty.conf"
alias reload="source ~/.zshrc"
alias tmuxconf="nvim ~/.tmux.conf"
alias c="clear"
alias lg="lazygit"
alias pa="php artisan"
alias pat="php artisan test"
alias patf="php artisan test --filter"
alias dotfiles="cd ~/.dotfiles && nvim . -c 'Telescope find_files hidden=true'"
alias copyhistory="fc -ln 0 | fzf --tac --no-sort | tr -d \\\n | pbcopy"
alias kmonadon="tmux new-session -ds kmonad kmonadrun"
alias kmonadoff="tmux kill-session -t kmonad"
alias kmonadrestart="kmonadoff && kmonadon"
alias nixrebuild="/run/current-system/sw/bin/nix run  --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake ~/.dotfiles/nix#default --impure"

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


# PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin":$PATH
export PATH="/Applications/kitty.app/Contents/MacOS":$PATH # makes kitty command work
export PATH="$HOME/.local/bin":$PATH
export PATH="~/bin":$PATH
export PATH="$HOME/.composer/vendor/bin":$PATH
export PATH="$HOME/.dotfiles/bin":$PATH
export PATH="$HOME/.cargo/bin":$PATH

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


