################
### ALIASES
################

autoload -Uz colors && colors

alias aliasx="alias | grep -v -e 'aliasx=' | sort | sed -E -e 's|^([^=]*)=(.*)|${fg_bold[blue]}\\\1###${fg[white]}\\\2${reset_color}|' | column -s '###' -t" # colorized alias
alias hashx="\hash | sed -E -e 's|^([^=]*)(=.*)|${fg_bold[blue]}\\\1${reset_color}\\\2|' | column -s '=' -t" # colorized hash command

alias history-edit='(){ ${1:-$EDITOR} $HISTFILE && fc -R }'

alias home='cd $HOME'
alias tmp='cd /tmp'

alias pid='(){ps -ax -o "pid, command" | grep --color=always "$1" | grep -v " grep "}'

alias type="'type' -a"

alias pick='fzf -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --no-sort --ansi' # fuzzy search and select anything

alias mv='command mv -i' # ask before overwrite file
alias cp='command cp -i' # ask before overwrite file
alias rm='command rm -i' # ask before remove file

alias ls='command ls -G' # G - colorize types,
alias ll='ls -hTpla' # h - human readable
if [ $commands[exa] ]; then
  alias ll='exa -Fla --group-directories-first' # h - human readable
fi

alias bat='bat --plain --paging never' # disable line numbers and paging by default

alias du="du -h" # h - human readable
alias df="df -h" # h - human readable

alias gls='command gls --color'
alias gll='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='command grep --color=auto' # colorize matching parts
alias less='command less -R -M -X' # -R : enable colors, -M : shows more detailed prompt, including file position -N : shows line number -X : supresses the terminal clearing at exit
  
alias http-server='command http-server -a localhost -p 8080'
alias https-server='command http-server -a localhost -p 8443 --ssl --cert $ZCONFIG_HOME/files/localhost.crt --key $ZCONFIG_HOME/files/localhost.key'

alias pwgen='() {command pwgen -scnyB1 ${1:-20}}'

alias rd='nl | sort -uk2 | sort -nk1 | cut -f2-'

alias weather='() {curl "wttr.in/$1"}' # print weather forecast for current location to prompt

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
