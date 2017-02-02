####################### zconfig ######################

export SELF_DIR="$(dirname $0)"
# export ZGEM_VERBOSE='true'
# export ZCONFIG_VERBOSE='true'

source "$SELF_DIR/zprofile.zsh"

if zprofile::active; then zprofile::before; fi

source "$SELF_DIR/zgem.zsh" # load zgem extension manager

zgem add 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'

zgem add 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
  bindkey '^[[A' history-substring-search-up     # bind arrow-up
  bindkey '^[[B' history-substring-search-down   # bind arrow-down

zgem add 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
zgem add 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker' from:'http' as:'completion'
zgem add 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose' from:'http' as:'completion'

zgem add 'https://github.com/rupa/z.git' from:'git' use:'z.sh'

zgem add "$SELF_DIR/modules/basic.zsh"
zgem add "$SELF_DIR/modules/color.zsh"

zgem add "$SELF_DIR/modules/completion.zsh"
zgem add "$SELF_DIR/modules/diff.zsh"
zgem add "$SELF_DIR/modules/docker.zsh"
zgem add "$SELF_DIR/modules/find.zsh"
# zgem add "$SELF_DIR/modules/git.zsh"
zgem add "$SELF_DIR/modules/history.zsh"
zgem add "$SELF_DIR/modules/http-server.zsh"
zgem add "$SELF_DIR/modules/man.zsh"
zgem add "$SELF_DIR/modules/maven.zsh"
zgem add "$SELF_DIR/modules/network.zsh"
zgem add "$SELF_DIR/modules/osx.zsh"
# zgem add "$SELF_DIR/modules/pane.zsh"
zgem add "$SELF_DIR/modules/process.zsh"
zgem add "$SELF_DIR/modules/prompt.zsh"
zgem add "$SELF_DIR/modules/random.zsh"
zgem add "$SELF_DIR/modules/ssh.zsh"
zgem add "$SELF_DIR/modules/sudo.zsh"
zgem add "$SELF_DIR/modules/which.zsh"

if zprofile::active; then zprofile::after; fi

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
    'profile')
      zprofile
      ;;
    *)
      zconfig::log error "Unknown command '$cmd'"
      zconfig::log error "Protocol: {edit|update|upgrade|profile}"
      return 1
      ;;
  esac
}

function zconfig::edit {
  local editor=${1:-$EDITOR}
  $editor "$SELF_DIR"
}

function zconfig::update {
  zconfig::log debug "${fg_bold[blue]}home directory${reset_color} $SELF_DIR"
  (cd $SELF_DIR; git pull)
}

function zconfig::log {
  local level="$1"
  shift

  case "$level" in
    'error')
      echo "${fg_bold[red]}[zconfig]${reset_color}" $@ >&2
      ;;
    'info')
      echo "${fg_bold[blue]}[zconfig]${reset_color}" $@
      ;;
    'debug')
      $ZCONFIG_VERBOSE && echo "${fg_bold[yellow]}[zconfig]${reset_color}" $@
      ;;
    *)
      zgem::log error "Unknown log level '$protocol'"
      zgem::log error "Log Level: {error|info|debug}"
      ;;
  esac
}
