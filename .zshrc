####################### zconfig ######################

export SELF_DIR="$(dirname $0)"

source "$SELF_DIR/zprofile.zsh" 

zprofile::active && zprofile::before

# export ZGEM_VERBOSE='true'
source "$SELF_DIR/zgem.zsh" # load zgem extension manager

MODUELS_DIR="$SELF_DIR/modules"
  
zgem add 'https://github.com/rupa/z.git' from:'git' use:'z.sh'
# zsh_bundle_plugin 'https://github.com/jimhester/per-directory-history'
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

zgem add "$MODUELS_DIR/basic.zsh"
zgem add "$MODUELS_DIR/color.zsh"

zgem add "$MODUELS_DIR/benchmark.zsh"
zgem add "$MODUELS_DIR/completion.zsh"
zgem add "$MODUELS_DIR/diff.zsh"
zgem add "$MODUELS_DIR/docker.zsh"
zgem add "$MODUELS_DIR/find.zsh"
# zgem add "$MODUELS_DIR/git.zsh"
zgem add "$MODUELS_DIR/history.zsh"
zgem add "$MODUELS_DIR/http-server.zsh"
zgem add "$MODUELS_DIR/man.zsh"
zgem add "$MODUELS_DIR/maven.zsh"
zgem add "$MODUELS_DIR/network.zsh"
zgem add "$MODUELS_DIR/osx.zsh"
# zgem add "$MODUELS_DIR/pane.zsh"
zgem add "$MODUELS_DIR/process.zsh"
zgem add "$MODUELS_DIR/prompt.zsh"
zgem add "$MODUELS_DIR/random.zsh"
zgem add "$MODUELS_DIR/ssh.zsh"
zgem add "$MODUELS_DIR/sudo.zsh"
zgem add "$MODUELS_DIR/which.zsh"

zprofile::active && zprofile::after

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
    'profile')
      zconfig::profile
      ;;
    *)
      echo "Unknown command '$cmd'"
      echo "Protocol: {edit|update} " >&2
      return 1 ;;
  esac
}

function zconfig::edit {
  local editor=${1:-$EDITOR}
  $editor "$ZSH_CONFIG_DIR"
}

function zconfig::update {
  # update self
  cd $ZSH_CONFIG_DIR;
  echo "${fg_bold[green]}* update config $(pwd)${reset_color}"
  git pull
  echo " "
  cd - 1> /dev/null
}

