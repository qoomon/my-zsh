export ZCONFIG_DIR="$(dirname $0)"

#### load zprofile plugin [lazy]
source "$ZCONFIG_DIR/plugins/zprofile.zsh"
if zprofile::active; then zprofile::before; fi

####################### config ######################

### load async plugin
source "$ZCONFIG_DIR/plugins/async.zsh"; 

#### load zgem extension manager
# export ZGEM_VERBOSE='true'
source "$ZCONFIG_DIR/plugins/zgem.zsh"

function zconfig {
  local cmd="$1"
  shift

  case "$cmd" in
    '');& 'edit')
      _zconfig::edit $@
      ;;
    'update')
      _zconfig::update
      ;;
    'upgrade')
      _zconfig::update
      zgem update
      ;;
    'reload')
      _zconfig::reload
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

function _zconfig::edit {
  local editor=${1:-$EDITOR}
  $editor "$ZCONFIG_DIR"
}

function _zconfig::update {
  echo "${fg_bold[blue]}[zconfig]${reset_color}" "${fg_bold[blue]}home directory${reset_color} $ZCONFIG_DIR"
  (cd $ZCONFIG_DIR; git pull)
}

function _zconfig::reload {
  exec "$SHELL" -l
}

#async source $ZCONFIG_DIR/config.zsh
source "$ZCONFIG_DIR/config.zsh"

if zprofile::active; then zprofile::after; fi
