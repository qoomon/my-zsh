ZCONFIG_HOME="$(dirname "$0")"

##### load extension manager
ZGEM_HOME="$HOME/.zgem"
ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"
test ! -e "$ZGEM_HOME" && git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

# # uncomment to load profiling extension (see below)
# zgem bundle 'https://github.com/qoomon/zprofile.git' from:'git' use:'zprofile.zsh'
# if zprofile::active; then zprofile::before; fi

##### zconfig function

function zconfig {
  local cmd="$1"
  shift

  case "$cmd" in
    'edit')
      _zconfig::edit $@
      ;;
    'update')
      _zconfig::update
      _zconfig::reload
      ;;
    'upgrade')
      _zconfig::upgrade
      _zconfig::reload
      ;;
    'reload')
      _zconfig::reload
      ;;
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

function _zconfig::upgrade {
  _zconfig::update
  zgem upgrade
}

function _zconfig::reload {
  exec "$SHELL" --login
}

##### load bundles

zgem bundle 'https://github.com/qoomon/zsh-jumper.git' from:'git' use:'jumper.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'  # origin 'https://github.com/zsh-users/zsh-history-substring-search.git'
zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'

zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/prompt.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

# # uncomment to load profiling extension
# if zprofile::active; then zprofile::after; fi


