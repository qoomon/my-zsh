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
      _ip::internal $@
      ;;
    'external'|'ext'|'e')
      _ip::external $@
      ;;
    *)
      _zgem::log error "Unknown command '$cmd'"
      _zgem::log error "Usage: $0 {internal|external}"
      return 1
      ;;
  esac
}

function _ip::internal {
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
        _zgem::log error "Unknown parameter '$param_key'"
        _zgem::log error "Parameter: {--interface <name>}"
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

function _ip::external {
  
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
        _zgem::log error "Unknown parameter '$param_key'"
        _zgem::log error "Parameter: {--details|--interface <name>}"
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