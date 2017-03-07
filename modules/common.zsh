autoload +X -U colors && colors

#print all default colors
function colors_ls {
  for k in "${(@k)fg}"; do
    echo "${fg[$k]}\${fg[$k]}$reset_color"
    echo "${fg_bold[$k]}\${fg_bold[$k]}$reset_color"
    echo "${bg[$k]}\${bg[$k]}$reset_color"
    echo "${bg_bold[$k]}\${bg_bold[$k]}$reset_color"
  done
}

function calc { 
  awk "BEGIN{ print $* }"
}

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
function j {
  local cmd="$1"
  case "$cmd" in
    '.')
      shift;
      local dir_query="$*"
      local dir="$(find . -type d -maxdepth 1 -mindepth 1 | sed 's|^\./\(.*\)|\1|' | fzf --query "$dir_query" --tac --select-1 --exit-0)"
      if [ -n "$dir" ]; then
        builtin cd "$dir"
      else
        echo "no directory matches"
        return 1
      fi
      ;;
    '..')
      shift;
      builtin cd .. $@
      ;;
    '...')
      shift;
      local pwd_list=('/' ${(s:/:)PWD%/*})
      local indexed_pwd_list=()
      for pwd_part_index in $(seq 1 ${#pwd_list}); do
          indexed_pwd_list[$pwd_part_index]="$pwd_part_index $pwd_list[$pwd_part_index]"
      done
      local pwd_index="$(printf "%s\n" "${indexed_pwd_list[@]}" | fzf --tac --with-nth=2.. | awk '{print $1}')"
      if [ -n "$pwd_index" ]; then
        local dir_list=(${pwd_list:0:$pwd_index})
        local dir="${(j:/:)dir_list}"
        builtin cd "$dir"
      else
        echo "no directory matches"
        return 1
      fi
      ;;
    '-')
      shift;
      builtin cd - $@ >/dev/null
      ;;
    '--')
      shift;
      local dir_query="$@"
      local dir="$(cdr -l | awk '{$1=""; print $0}' | fzf --tac --query "$dir_query" --select-1 --exit-0)"
      if [ -n "$dir" ]; then
        eval "builtin cd ${dir}"
      else
        echo "no directory matches"
        return 1
      fi
      ;;
    *)
      builtin cd $@
      ;;
  esac
}


function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion


function man_colorized {
  env \
    LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
    LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
    LESS_TERMCAP_ue=$(printf "$reset_color") \
    PAGER="${commands[less]:-$PAGER}" \
    _NROFF_U=1 \
  'man' $@
}
type compdef >/dev/null && compdef _man man_colorized # set default completion

function diff_colorized {
  local opt="\{0,1\}"
  'diff' $@ | sed \
      -e "s|^\(<.*\)|${fg[red]}\1$reset_color|" \
      -e "s|^\(>.*\)|${fg[green]}\1$reset_color|" \
      -e "s|^\([a-z0-9].*\)|${fg_bold[cyan]}\1$reset_color|" \
      -l
  return ${pipestatus[1]}
}
type compdef >/dev/null && compdef _diff diff_colorized # set default completion

# ipinfo.io/ip;   ipinfo.io/json
# ifconfig.co/ip;   ifconfig.co/json
# api.ipify.org
function ip {
  local cmd="$1"
  [[ $# > 0 ]] && shift

  case "$cmd" in
    'internal'|'int'|'i')
      __ip::internal $@
      ;;
    'external'|'ext'|'e')
      __ip::external $@
      ;;
    *)
      echo "Unknown command '$cmd'" >&2
      echo "Usage: $0 {internal|external}" >&2
      return 1
      ;;
  esac
}

function __ip::internal {
  local interface=""

  while [[ $# > 0 ]] ; do
    local param_key="$1"
    shift

    case "$param_key" in
      '--interface'|'-i')
        interface="$1"
        shift
        ;;
      *)
        echo "Unknown parameter '$param_key'" >&2
        echo  "Parameter: {--interface <name>}" >&2
        return 1
        ;;
    esac
  done

  if [ -z "$interface" ]; then
    local interface_list=($(ifconfig -l))
    for interface in $interface_list; do
        local ip=$(ipconfig getifaddr $interface)
        if [ -n "$ip" ]; then
          echo "$interface: $ip"
        fi
    done
  else
    echo $(ipconfig getifaddr $interface)
  fi
}

function __ip::external {

  local interface=""
  local details=false

  while [[ $# > 0 ]] ; do
    local param_key="$1"
    shift

    case "$param_key" in
      '--interface'|'-i')
        interface="$1"
        shift
        ;;
      '--details'|'-d')
        details="true"
        ;;
      *)
        echo "Unknown parameter '$param_key'" >&2
        echo "Parameter: {--details|--interface <name>}" >&2
        return 1
        ;;
    esac
  done

  local interface_param
  if [ -n "$interface" ]; then
    interface_param=(--interface $interface)
  fi

  local address="ipinfo.io/ip"
  if $details; then
    address="ipinfo.io/json"
  fi

  curl $interface_param $address
}

function gauth {
  local secretBase32=$1
  watch -n1 'echo $(oathtool --totp --base32 '$secretBase32') $(expr 30 - $(date +%s) % 30)s'
}
