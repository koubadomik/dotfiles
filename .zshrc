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
    poetry
    extract
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    k
    copyfile
    web-search
    copybuffer
    zsh-fzf-history-search
    docker 
    docker-compose
)

source $ZSH/oh-my-zsh.sh
#PROMPT="%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%d%{$reset_color%} $(git_prompt_info)"

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
export PATH="$PATH:/Users/koubadom/.local/bin" #pipx
export PATH="$PATH:/Users/koubadom/.npm_local/bin/" #npx, npm


fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIREC=1
export HOMEBREW_CASK_OPTS=--require-sha

export OPENBLAS=$(/opt/homebrew/bin/brew --prefix openblas)
export ARROW_HOME=$(brew --prefix apache-arrow)
export LLVM_CONFIG="$(brew --prefix llvm@11)/bin/llvm-config" 
export PATH="/opt/homebrew/opt/openssl@1.1/bin:${LLVM_CONFIG}:/opt/homebrew/bin:${PATH}"
export CFLAGS="-I$(brew --prefix openssl@1.1)/include"
export CFLAGS="-falign-functions=8 ${CFLAGS}"
export LDFLAGS="-L$(brew --prefix openssl@1.1)/lib" 
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export PATH="/Users/koubadom/Projects/bp-forjerry/tools/data-manipulation/cli-tools:${PATH}"
export PATH="$HOME/.tfenv/bin:$PATH"

#Functions
assume_role(){
    echo "Assuming IAM role: '${1}' with session name '${2}'"
    KST=($(aws sts assume-role --role-arn ${1} --role-session-name ${2} --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text))
    unset AWS_SECURITY_TOKEN
    export AWS_ACCESS_KEY_ID=${KST[1]} AWS_SECRET_ACCESS_KEY=${KST[2]} AWS_SESSION_TOKEN=${KST[3]}
}

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

function sample_dataset(){
    sso experiment-pdf
    TENANT_PREFIX="$1"
    START_DAY="$2"
    END_DATE="$3"
    DATASET_NAME="dataset"
    OUTPUT_DIR=/Users/koubadom/data/resistant/datasets
    poetry run /Users/koubadom/Projects/bp-forjerry/projects/bp-forjerry/training/dataset_builder --start_date=${START_DAY} --dataset_name=${DATASET_NAME} --output_dir=${OUTPUT_DIR} --end_date=${END_DATE} --data_prefix="${TYPE}/${TENANT_PREFIX}"
}

function download_data_set(){
    IFS=$'\n' read -d '' -A arr2 < <(cat "${1}"| jq ".input_file")
    p="/Users/koubadom/data/resistant/data/files/${1}/"
    echo $arr[1]
    echo $p
    mkdir "${p}"
    for i in "${arr2[@]}"
    do
        if [ -n "$i" ]; then
            temp="${i%\"}"
            temp="${temp#\"}"
            # echo "s3://${temp}" "${p}"
            s3cp "s3://${temp}" "${p}"
        fi
    done
}

function sync_pipeline(){
    s3sync s3://bp-pdf-experiment/datasets/dataset_$1/$2/img/assembly/ ~/data/resistant/pipeline/$1/$2/img/assembly/
    s3sync s3://bp-pdf-experiment/datasets/dataset_$1/$2/pdf/assembly/ ~/data/resistant/pipeline/$1/$2/pdf/assembly/
}


function check_data_set(){
    IFS=$'\n' read -d '' -A arr2 < <(cat "${1}"| jq ".input_file")
    k=0
    for i in "${arr2[@]}"
    do
        if [ -n "$i" ]; then
            ((k=k+1)) 
           temp="${i%\"}"
           temp="${temp#\"}"
           echo -ne "${k}/${#arr2[@]}\r"
           s3ls "s3://${temp}" > /dev/null || echo "Not found ${temp}"
        fi
    done
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

com() {
    git commit -m "#$(git rev-parse --abbrev-ref HEAD | cut -d"-" -f1): $1"
}

mr() {
    git fetch
    git checkout $(git branch -a | grep $1 | rev | cut -d/ -f1 | rev | head -n 1)

}


#Aliases
alias b="/Users/koubadom/Library/Caches/pypoetry/virtualenvs/bible-scraper-gzNJyYRW-py3.10/bin/python ~/Projects/bible-scraper/scraper.py verse --path ~/Projects/bible-scraper/bible/books.json"
alias lb="/Users/koubadom/Library/Caches/pypoetry/virtualenvs/bible-scraper-gzNJyYRW-py3.10/bin/python ~/Projects/bible-scraper/scraper.py ls --path ~/Projects/bible-scraper/bible/books.json"
alias sb="/Users/koubadom/Library/Caches/pypoetry/virtualenvs/bible-scraper-gzNJyYRW-py3.10/bin/python ~/Projects/bible-scraper/scraper.py search --path ~/Projects/bible-scraper/bible/books.json"
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



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/koubadom/Projects/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/koubadom/Projects/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/koubadom/Projects/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/koubadom/Projects/google-cloud-sdk/completion.zsh.inc'; fi
