####################### zconfig ######################

function zconfig {
  local cmd="$1"
  shift

  case "$cmd" in
    '');& 'edit')
      zconfig::edit $@
      ;;
    'update')
      zconfig::update
      ;;
    'upgrade')
      zconfig::update
      zgem update
      ;;
    'reload')
      zconfig::reload
      ;;
    'profile')
      zprofile $@
      ;;
    *)
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Unknown command '$cmd'" >&2
      echo "${fg_bold[red]}[zconfig]${reset_color}" "Protocol: {edit|update|upgrade|reload|profile}" >&2
      return 1
      ;;
  esac
}

function zconfig::edit {
  local editor=${1:-$EDITOR}
  $editor "$ZCONFIG_DIR"
}

function zconfig::update {
  echo "${fg_bold[blue]}[zconfig]${reset_color}" "${fg_bold[blue]}home directory${reset_color} $ZCONFIG_DIR"
  (cd $ZCONFIG_DIR; git pull)
}

function zconfig::reload {
  exec "$SHELL" -l
}