# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/koubadom/.oh-my-zsh"
ZSH_THEME="gnzh"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder
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
    vi-mode
    docker 
    docker-compose
)

source $ZSH/oh-my-zsh.sh
#PROMPT="%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%d%{$reset_color%} $(git_prompt_info)"
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# MY
#Configs
if [[ $(arch) == "arm64" ]]; then 
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

PATH=$PATH:/usr/local/bin
export PATH="$HOME/.poetry/bin:$PATH"
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
export OPENBLAS=$(/opt/homebrew/bin/brew --prefix openblas)
export CFLAGS="-falign-functions=8 ${CFLAGS}"
export ARROW_HOME=$(brew --prefix apache-arrow)
export LLVM_CONFIG=/opt/homebrew/Cellar/llvm@11/11.1.0_3/bin/llvm-config
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIREC=1
export HOMEBREW_CASK_OPTS=--require-sha
export PATH="$PATH:/Users/koubadom/.local/bin" #pipx

#temp
export PATH="/opt/homebrew/opt/openssl@1.1/bin:/opt/homebrew/Cellar/llvm@11/11.1.0_3/bin:/opt/homebrew/bin:${PATH}"
#export PATH="/opt/homebrew/opt/openssl@1.1/bin:/opt/homebrew/bin:${PATH}"
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export OPENBLAS=$(/opt/homebrew/bin/brew --prefix openblas)
export CFLAGS="-falign-functions=8 ${CFLAGS}"


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

function download_data_set(){
    IFS=$'\n' read -d '' -A arr2 < <(cat "${1}"| jq ".input_file")
    p="/Users/koubadom/data/resistant/files/${1}/"
    echo $arr[1]
    echo $p
    mkdir "${p}"
    for i in "${arr2[@]}"
    do
        if [ -n "$i" ]; then
            temp="${i%\"}"
            temp="${temp#\"}"
            #echo "s3://${temp}" "${p}"
            s3cp "s3://${temp}" "${p}"
        fi
    done
}

function sync_pipeline(){
    s3sync s3://bp-pdf-experiment/datasets/dataset_$1/$2/img/assembly/ ~/data/resistant/pipeline/$1/$2/img/assembly/
    s3sync s3://bp-pdf-experiment/datasets/dataset_$1/$2/pdf/assembly/ ~/data/resistant/pipeline/$1/$2/pdf/assembly/
}

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



#Aliases
alias ros="arch -x86_64"
alias arm="arch -arm64e"
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
alias d='executeAndCopy pwd'
alias c=echoAndCopy
alias o='open ./'
alias ct='cpclip'
alias ctj='cpclipjs'
alias gst='gss'


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



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
