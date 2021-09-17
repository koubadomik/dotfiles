# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/koubadom/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
    extract
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    k
    copyfile
    web-search
    copybuffer
    zsh-fzf-history-search
)

source $ZSH/oh-my-zsh.sh

PROMPT="%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%5~%{$reset_color%} $(git_prompt_info)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# MY

#Configs
if [[ $(arch) == "arm64" ]]; then 
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
#PATH=$PATH:/opt/homebrew/bin
PATH=$PATH:/usr/local/bin
export PATH="$HOME/.poetry/bin:$PATH"

fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
export OPENBLAS=$(/opt/homebrew/bin/brew --prefix openblas)
export CFLAGS="-falign-functions=8 ${CFLAGS}"
export ARROW_HOME=$(brew --prefix apache-arrow)
#export LLVM_CONFIG=/Users/koubadom/Projects/llvm-9.0.1.src/install/bin/llvm-config
export LLVM_CONFIG=/opt/homebrew/Cellar/llvm@11/11.1.0_2/bin/llvm-config
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIREC=1
export HOMEBREW_CASK_OPTS=--require-sha

#Aliases
alias ros="arch -x86_64"
alias arm="arch -arm64e"
#alias python3='python'
alias brewi='arch -x86_64 /usr/local/bin/brew'
alias brewa='arch -arm64e /opt/homebrew/bin/brew'
alias ff='find . -name'
alias ll='ls -l'
alias zsed='vim ~/.zshrc'
alias zrun='source ~/.zshrc'
alias psv='poetry show -v'
alias pi='poetry install'
alias hist='sort | uniq -c | sort'
alias cd..='cd ..'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias path='echo -e ${PATH//:/\\n}'
alias confl='git diff --name-only --diff-filter=U'

alias blib='cd ~/Projects/bp-forjerry/lib/bp-forjerry'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/koubadom/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/koubadom/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/koubadom/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/koubadom/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#Functions
function maws (){
    aws s3 ls --human-readable s3://$1 
}

function inspdf(){
    qpdf --qdf --object-streams=disable $1 to_inspect.pdf
}

function sso () {
	export AWS_DEFAULT_REGION=eu-west-1
	unset AWS_PROFILE && export PROFILE_AWS=$1
	aws-sso-util login --profile $1
	eval $(aws-export-credentials --env-export --profile $1)
}

function clm() { awk "{print \$${1:-1}}"; }

function cpclip() {
    cat $1 | pbcopy
}

function cpclipjs() {
    cat $1 | jq | pbcopy
}

function authaws() {
    . ~/Projects/scripts/awspypi.sh
    sso experiment-pdf
}

# Created by `pipx` on 2021-08-19 10:15:03
export PATH="$PATH:/Users/koubadom/.local/bin"


# By Lukas
s3cp() {
  aws s3 cp --sse AES256 "${1}" "${2}"
}

s3sync() {
  aws s3 sync --sse AES256 "${1}" "${2}"
}
s3ls() {
  aws s3 ls "${1}"
}

# note: nested quotes does not work, double-quotes have to be used
dashForEnd() {
	$1 | tr "\n" /
}
executeAndCopy() {
	echo `dashForEnd $1`$2 | tr -d "\n" | pbcopy
}
echoAndCopy() {
	echo $1 | tr -d "\n" | pbcopy
}

alias d='executeAndCopy pwd'
alias c=echoAndCopy
alias o='open ./'
alias ct='cpclip'
alias ctj='cpclipjs'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
