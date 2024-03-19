# export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH



# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# POWERLEVER9K CONFIG
#ZSH_THEME="powerlevel9k/powerlevel9k"
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
#POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
    # zsh-syntax-highlighting
#	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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

alias pest="./vendor/bin/pest"

# Personal export
export EDITOR='nvim'
gswf() {
    # use git branch --all to dislay all branches
    git switch "$(git branch  | fzf --tac | tr -d '[:space:]')"
}


# enable syntax highlighting
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

#Create directory/ies and cd into it in one command
mkcd() {
    mkdir -p "$1" && cd "$1"
}

jvac() {
    javac $1.java && java $1 ;
}

#Promt customization

# Load version control information
# autoload -Uz vcs_info
# precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:git:*' formats 'on %b'
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
#PROMPT='${PWD/#$HOME/~} ${vcs_info_msg_0_} > '
PROMPT='~ '


# export NVM_DIR="/Users/mbp-greg/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Affinity Support FE aliases
refresh() {
    if [ -f "vendor/laravel/sail/bin/sail" ]
	then
		bash vendor/bin/sail composer install
		bash vendor/bin/sail php artisan tenants:migrate-fresh
		bash vendor/bin/sail php artisan tenants:seed --class=TestingDatabaseSeeder
	elif [ -f "lerna.json" ]
	then
		yarn install
		yarn workspaces run build:package
	else
		echo "Don't know what to do"
	fi
}

up() {
    if [ -f "vendor/laravel/sail/bin/sail" ]
	then
		bash vendor/bin/sail up -d
	elif [ -f "lerna.json" ]
	then
		screen -S watch -dm yarn workspace @akj-dev/cpq build:watch
		screen -S api -dm yarn workspace @akj-dev/dc-mock-api start
		screen -S app -dm yarn workspace @akj-dev/affinity-${1:=support-new} start
		echo "Started @akj-dev/cpq"
		echo "Started @akj-dev/dc-mock-api"
		echo "Started @akj-dev/affinity-${1:=support-new}"
	else
		echo "Don't know what to do"
	fi
}
down() {
    screen -ls | egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} '(watch|app|api)' | cut -d. -f1 | awk '{print $1}' | xargs kill
		kill -9 $(ps aux | grep yarn | grep exclude -v | awk '{print $2}')
		echo "Done"
}

init-sail () {
	docker run --rm -u "$(id -u):$(id -g)" -v $(pwd):/var/www/html -w /var/www/html laravelsail/php80-composer:latest composer install --ignore-platform-reqs
}

fresh () {
        if [ -f "lerna.json" ]
        then
                find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
                find . -name 'dist' -type d -prune -exec rm -rf '{}' +
        fi
}
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/Applications/kitty.app/Contents/MacOS":$PATH # makes kitty command work
export PATH="$HOME/.local/bin":$PATH
export PATH="~/bin":$PATH


# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --exclude 'node_modules'"
export FZF_CTRL_T_COMMAND="fd -t f -I -E 'node_modules' -E 'vendor' . ."
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

daisy_vpn () {
	sshuttle --dns --daemon --pidfile ~/.ssh/sshuttle.pid -r greg.grigorjevs@dsbastion07-public 10.0.0.0/8 195.0.0.0/8
}

daisy_vpn_disconnect () {
	kill -9 $(cat ~/.ssh/sshuttle.pid)
}


# Herd injected PHP binary.
export PATH="/Users/mbp-greg/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/mbp-greg/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/mbp-greg/Library/Application Support/Herd/config/php/74/"

# custom bindings
bindkey -s ^f "tmux_sessionizer\n"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

