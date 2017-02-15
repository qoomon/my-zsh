SELF_DIR="${0:A:h}"

#### load zprofile plugin [lazy]
source "$SELF_DIR/plugins/zprofile.zsh"
if zprofile::active; then zprofile::before; fi

#### load zgem extension manager
# ZGEM_VERBOSE='true'
source "$SELF_DIR/plugins/zgem.zsh"

zgem bundle 'https://github.com/rupa/z.git' from:'git' use:'z.sh'

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh' && {
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
}

zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
zgem bundle 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker' from:'http' as:'completion'
zgem bundle 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose' from:'http' as:'completion'

zgem bundle "$SELF_DIR/modules/general.zsh"
zgem bundle "$SELF_DIR/modules/history.zsh"
zgem bundle "$SELF_DIR/modules/prompt.zsh"
zgem bundle "$SELF_DIR/modules/completion.zsh"
zgem bundle "$SELF_DIR/modules/alias.zsh"

zgem bundle "$SELF_DIR/utils/which.zsh"
zgem bundle "$SELF_DIR/utils/find.zsh"
zgem bundle "$SELF_DIR/utils/network.zsh"
zgem bundle "$SELF_DIR/utils/process.zsh"
zgem bundle "$SELF_DIR/utils/ssh.zsh"
zgem bundle "$SELF_DIR/utils/git.zsh"
zgem bundle "$SELF_DIR/utils/docker.zsh"
zgem bundle "$SELF_DIR/utils/http-server.zsh"

zgem bundle "$SELF_DIR/utils/maven.zsh"
zgem bundle "$SELF_DIR/utils/osx.zsh"
zgem bundle "$SELF_DIR/utils/pane.zsh"

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
  ${1:-$EDITOR} "$SELF_DIR"
}

function _zconfig::update {
  echo "${fg_bold[blue]}[zconfig]${reset_color}" "${fg_bold[green]}update ${fg_bold[black]}($SELF_DIR)${reset_color}"
  (cd $SELF_DIR; git pull)
}

function _zconfig::reload {
  exec "$SHELL" --login
}
