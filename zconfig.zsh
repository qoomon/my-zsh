local ZCONFIG_HOME="${0:A:h}"

#### load zprofile plugin [lazy]
source "$ZCONFIG_HOME/plugins/zprofile.zsh"
if zprofile::active; then zprofile::before; fi

#### load zgem extension manager
# ZGEM_VERBOSE='true'
source "$ZCONFIG_HOME/plugins/zgem.zsh"

zgem bundle 'https://github.com/rupa/z.git' from:'git' use:'z.sh'

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'

zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
zgem bundle 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker' from:'http' as:'completion'
zgem bundle 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose' from:'http' as:'completion'

zgem bundle "$ZCONFIG_HOME/utils/network.zsh"
zgem bundle "$ZCONFIG_HOME/utils/http-server.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/which.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/find.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/process.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/ssh.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/git.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/docker.zsh"

zgem bundle "$ZCONFIG_HOME/utils/maven.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/osx.zsh"
# zgem bundle "$ZCONFIG_HOME/utils/pane.zsh"

zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/prompt.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/common.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

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
