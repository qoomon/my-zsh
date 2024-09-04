autoload -U colors && colors
autoload -U keeper

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

setopt MULTIOS  # enable multi output streams
setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt INTERACTIVE_COMMENTS # Allowes to use #-sign as comment within commandline
export WORDCHARS='' # threat every special charater as word delimiter

# defaut editor
bindkey -e # ensure emacs mode
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

# colorize file system view
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"
# colorize file system view (macOS)
export LSCOLORS="Exfxcxdxbxegedabagacad"

# support colors in less
export LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
export LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
export LESS_TERMCAP_ue=$(printf "$reset_color")

export GPG_TTY=$(tty)

### fzf configuration
if [ $commands[fzf] ]
then
  export FZF_DEFAULT_OPTS='
    --color fg:-1,bg:-1,hl:5,fg+:3,bg+:-1,hl+:5
    --color info:42,prompt:-1,spinner:42,pointer:51,marker:33
    --exact
    --ansi'
  if [ $commands[fd] ]
  then
    export FZF_DEFAULT_COMMAND="fd -c always"
  fi
fi


################################################################################
####### Utils ##################################################################
################################################################################

function pid {
  ps -ax -o "pid, command" \
  | grep --color=always "$1" \
  | grep -v " grep "
}

 # colorized alias list
function alias-list {
  alias | sort \
  | sed -E -e "s|^([^=]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2${reset_color}|" \
  | column -s '###' -t
}

# colorized command list
function hash-list {
  hash | grep -v -e 'hashx=' | sort \
  | sed -E -e "s|^([^=]*)(=.*)|${fg_bold[blue]}\1${reset_color}\2|" \
  | column -s '=' -t
}

# make directory and jump into it
function tkdir { mkdir $@ && cd $_ }

# Print line annotation with comment
function annotate {
  local comment=$1
  echo
  echo "${bg[grey]}${fg_bold[default]}\e[2K# ${comment}${reset_color}"
  echo
}

# executes given commad in every sub directory
function workspace {
  local workspace=$PWD
  local dir
  for dir in */; do
    ( cd $dir && printf "\\e[34m${PWD#$workspace/}:\\e[39m\\n" && eval "$@" && echo )
  done
}

# generate random characters
function random {
  local character_count=${1:-32}
  local character_set=${2:-'A-Za-z0-9!#$%&()*+,-./:;<=>?@[]^_`{|}~'}
  head /dev/urandom | LC_ALL=C tr -dc $character_set | fold -w $character_count | head -1
}

# print weather forecast for current location to prompt
function weather { curl "wttr.in/$1" }

# colorized man
function man {
  LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
  LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
  LESS_TERMCAP_ue=$(printf "$reset_color") \
  PAGER="${commands[less]:-$PAGER}" \
  _NROFF_U=1 \
     command man "$@"
}

# colorized diff
function diff {
  command diff "$@" | sed \
    -e "s|^\(<.*\)|${fg[red]}\1$reset_color|" \
    -e "s|^\(>.*\)|${fg[green]}\1$reset_color|" \
    -e "s|^\([a-z0-9].*\)|${fg_bold[cyan]}\1$reset_color|" \
    -l
  return ${pipestatus[1]}
}

function git-take() {
    git clone "$@"
    local param
    local last_arg
    for param; do
        if [[ $param != -* ]]; then
            last_arg="$param"
        fi
    done
    clone_dir=$(basename $last_arg .git)
    cd $clone_dir;
}
alias tkgit='git-take'

################################################################################
####### Aliases ################################################################
################################################################################

alias sudo='sudo ' # allow aliases to work with sudo

alias tmp='cd $(mktemp -d /tmp/XXXXXXXXXX)' # create temporary directory and jump into it

alias type="type -a"

if [ $commands[fzf] ]; then
  alias pick='fzf -m --bind "ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all,ctrl-y:execute-silent(printf \"%s\\n\" {+} | pbcopy)" --no-sort --ansi' # fuzzy search and select anything
fi

alias cd='>/dev/null cd' # prevent stdout of special commands e.g. cd -
alias mv='mv -i' # ask before overwrite file
alias cp='cp -i' # ask before overwrite file
alias rm='rm -i' # ask before remove file

alias ls='ls -G' # G - colorize types,
alias ll='ls -lpch' # -l : details; -p : file indicator; -c : last modified date; -u : last usage date; -h : human readable;
if [ $commands[eza] ]
then
  alias eza='eza --group-directories-first --classify'
  alias el='eza -l'
fi

alias bat='bat --style=plain --paging never' # disable line numbers and paging by default
alias du="du -h" # -h : human readable;
alias df="df -h" # -h : human readable;

alias gls='gls --color'
alias gll='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='grep --color=auto' # colorize matching parts
alias less='less -R -M -X' # -R : enable colors; -M : shows more detailed prompt, including file position; -N : shows line number; -X : supresses the terminal clearing at exit;


if [ $commands[http-server] ]
then
    alias http-server='\http-server -a localhost -p 8080'
    # you may generate cert and key with following command
    #   mkcert -cert-file "$HOME/localhost.pem" -key-file "$HOME/localhost-key.pem" localhost '*.local' '*.host.local'
    alias https-server='\http-server -a localhost -p 8443 --ssl --cert "$HOME/localhost.pem" --key "$HOME/localhost-key.pem"'
else
    alias http-server='python -m http.server --bind localhost 8080'
fi

alias pwgen='pwgen -scnyB1'

alias epoch='date +%s' # print current epoch seconds

alias wordcount="tr -s ' ' | tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr"

# alias -s jpeg="open" # sufix alias

################################################################################
####### Key Bindings ###########################################################
################################################################################

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# IntelliJ Bindings
if [[ $TERMINAL_EMULATOR == 'JetBrains-JediTerm' ]]
then
  bindkey "^[^[[D" beginning-of-line
  bindkey "^[^[[C" end-of-line
fi
