SELF_DIR="$(dirname "$0")"
local ZCONFIG_HOME="$SELF_DIR"

#### load zprofile plugin [lazy]
source "$ZCONFIG_HOME/plugins/zprofile.zsh"
if zprofile::active; then zprofile::before; fi

#### load zgem extension manager
# ZGEM_VERBOSE='true'
source "$ZCONFIG_HOME/plugins/zgem.zsh"

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
# zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'
zgem bundle 'https://github.com/qoomon/zsh-history-substring-search' from:'git' use:'zsh-history-substring-search.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'

zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/prompt.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

zgem bundle "$ZCONFIG_HOME/utils/common.zsh"
zgem bundle "$ZCONFIG_HOME/utils/jumper.zsh"
zgem bundle "$ZCONFIG_HOME/utils/ip.zsh"
zgem bundle "$ZCONFIG_HOME/utils/maven.zsh"

if zprofile::active; then zprofile::after; fi

############## zconfig util function

function zconfig {
  local cmd="$1"
  shift

  case "$cmd" in
    '');& 'edit')
      _zconfig::edit $@;;
    'update')
      _zconfig::update;;
    'upgrade')
      _zconfig::update; zgem update;;
    'reload')
      _zconfig::reload;;
    'profile')
      zprofile $@;;
    *)
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Unknown command '$cmd'" >&2
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Protocol: {edit|update|upgrade|reload|profile}" >&2
      return 1
      ;;
  esac
}

function _zconfig::edit {
  ${1:-$EDITOR} "$ZCONFIG_HOME"
}

function _zconfig::update {
  echo "${fg_bold[blue]}[zconfig]${reset_color}" "${fg_bold[green]}update ${fg_bold[black]}($ZCONFIG_HOME)${reset_color}"
  (cd $ZCONFIG_HOME; git pull)
}

function _zconfig::reload {
  exec "$SHELL" --login
}
