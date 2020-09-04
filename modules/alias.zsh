################
### ALIASES
################

autoload -Uz colors && colors

function aliasx { # colorized alias
  alias | sort \
  | sed -E -e "s|^([^=]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2${reset_color}|" \
  | column -s '###' -t 
}

function hashx { # colorized hash command
  hash | grep -v -e 'hashx=' | sort \
  | sed -E -e "s|^([^=]*)(=.*)|${fg_bold[blue]}\1${reset_color}\2|" \
  | column -s '=' -t
}

function history-edit { ${1:-$EDITOR} $HISTFILE && fc -R }

function history-edit { ps -ax -o "pid, command" | grep --color=always "$1" | grep -v " grep " }

alias type="type -a"

if [ $commands[fzf] ]; then
  alias pick='fzf -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --no-sort --ansi' # fuzzy search and select anything
fi

alias cd='>/dev/null cd' # prevent stdout of special commands e.g. cd -
alias mv='mv -i' # ask before overwrite file
alias cp='cp -i' # ask before overwrite file
alias rm='rm -i' # ask before remove file
function tkdir { mkdir $@ && cd $_ }

alias ls='ls -G' # G - colorize types,
alias ll='ls -laphc' # -l : details; -p : file indicator; -c : last modified date; -u : last usage date; -h : human readable;
if [ $commands[exa] ]
then
  alias exa='exa --group-directories-first --classify' 
  alias el='exa -Fla '
fi

alias bat='bat --plain --paging never' # disable line numbers and paging by default

alias du="du -h" # -h : human readable;
alias df="df -h" # -h : human readable;

alias gls='gls --color'
alias gll='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='grep --color=auto' # colorize matching parts
alias less='less -R -M -X' # -R : enable colors; -M : shows more detailed prompt, including file position; -N : shows line number; -X : supresses the terminal clearing at exit;
  
alias http-server='http-server -a localhost -p 8080'
alias https-server='http-server -a localhost -p 8443 --ssl --cert $ZCONFIG_HOME/files/localhost.crt --key $ZCONFIG_HOME/files/localhost.key'

alias pwgen='pwgen -scnyB1'

alias epoch='date +%s' # print current epoch seconds

function weather { curl "wttr.in/$1" } # print weather forecast for current location to prompt

alias wordcount="tr -s ' ' | tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr"

# alias -s jpeg="open" # sufix alias

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

# Print line annotation with comment 
function annotate {
  local comment=$1
  echo
  echo "${bg[grey]}${fg_bold[default]}\e[2K# ${comment}${reset_color}"
  echo
}

### executes given commad in every sub directory
function workspace {
  local workspace=$PWD
  local dir
  for dir in */; do
    ( cd $dir && printf "\\e[34m${PWD#$workspace/}:\\e[39m\\n" && eval "$@" && echo )
  done
}

### generate random characters
function random {
  local character_count=${1:-32}
  local character_set=${2:-'A-Za-z0-9!#$%&()*+,-./:;<=>?@[]^_`{|}~'}
  head /dev/urandom | LC_ALL=C tr -dc $character_set | fold -w $character_count | head -1
}
