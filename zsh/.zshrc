eval "$(starship init zsh)"

#export HISTFILE="~/.zsh_history"
export HISTFILESIZE=
export HISTSIZE=10000
export SAVEHIST=10000

setopt share_history


# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias vim="nvim"
alias zshconfig="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias vimconf="nvim ~/.config/nvim"
alias alacrittyconfig="vim ~/.config/alacritty/alacritty.yml"
alias kittyconfig="nvim ~/.config/kitty/kitty.conf"
alias reload="source ~/.zshrc"
alias tmuxconf="nvim ~/.tmux.conf"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias c="clear"
alias uni="cd  '/Users/grigorijgrigorjev/Library/Mobile Documents/com~apple~CloudDocs/Uni Icloud/Uni/Year 2'"
alias sail="./vendor/bin/sail"
alias support="sail artisan"
alias satf="support test --filter"
alias sai="support insights"
alias seeddb="support tenants:seed --class=DemoDatabaseSeeder"
alias remigrate="support tenants:migrate-fresh && seeddb"
alias greptest="support test --list-tests | grep"
alias affsupport="cd /Users/mbp-greg/programming/work/aurora/affinity-support"
alias cdaurora="cd ~/programming/work/aurora"
alias sourcezsh="source ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias sourcevim="source ~/.vimrc"
# alias brew="arch -x86_64 brew"
alias lg="lazygit"
alias pa="php artisan"
alias pat="php artisan test"
alias patf="php artisan test --filter"
alias dotfiles="cd ~/.dotfiles && nvim . -c 'Telescope find_files hidden=true'"
alias copyhistory="fc -ln 0 | fzf --tac --no-sort | tr -d \\\n | pbcopy"
alias kmonadon="tmux new-session -ds kmonad kmonadrun"
alias kmonadoff="tmux kill-session -t kmonad"
alias kmonadrestart="kmonadoff && kmonadon"

alias pest="./vendor/bin/pest"

# Personal export
export EDITOR='nvim'
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

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/Applications/kitty.app/Contents/MacOS":$PATH # makes kitty command work
export PATH="$HOME/.local/bin":$PATH
export PATH="~/bin":$PATH
export PATH="$HOME/.composer/vendor/bin":$PATH
export PATH="$HOME/.dotfiles/bin":$PATH

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# fzf config
source <(fzf --zsh)
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

# custom bindings
bindkey -s ^f "tmux_sessionizer\n"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


source /Users/gregg/.config/broot/launcher/bash/br

# zplug
source ~/.zplug/init.zsh
zplug "jeffreytse/zsh-vi-mode"

# wrapper around yazi. use this to change the cwd on exit
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
