ZCONFIG_HOME=${ZCONFIG_HOME:-"$HOME/.zsh"}

function zconfig {
  local cmd="$1"
  shift

  case "$cmd" in
    'edit')
      _zconfig::edit $@
      ;;
    'update')
      _zconfig::update
      zgem upgrade
      _zconfig::reload
      ;;
    'reload')
      _zconfig::reload
      ;;
    'profile')
      zprofile $@
      ;;
    *)
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Unknown command '$cmd'" >&2
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Protocol: {edit|update|reload|profile}" >&2
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
