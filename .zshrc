export ZSH_CONFIG_DIR="$(dirname $0)"
export ZSH_MODUELS_DIR="$ZSH_CONFIG_DIR/modules"

function zconfig::load {
  
  # load zgem extension manager
  source "$ZSH_CONFIG_DIR/zgem.zsh" 

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

  zgem add "$ZSH_MODUELS_DIR/basic.zsh"
  zgem add "$ZSH_MODUELS_DIR/color.zsh"

  zgem add "$ZSH_MODUELS_DIR/benchmark.zsh"
  zgem add "$ZSH_MODUELS_DIR/completion.zsh"
  zgem add "$ZSH_MODUELS_DIR/diff.zsh"
  zgem add "$ZSH_MODUELS_DIR/docker.zsh"
  zgem add "$ZSH_MODUELS_DIR/find.zsh"
  # zgem add "$ZSH_MODUELS_DIR/git.zsh"
  zgem add "$ZSH_MODUELS_DIR/history.zsh"
  zgem add "$ZSH_MODUELS_DIR/http-server.zsh"
  zgem add "$ZSH_MODUELS_DIR/man.zsh"
  zgem add "$ZSH_MODUELS_DIR/maven.zsh"
  zgem add "$ZSH_MODUELS_DIR/network.zsh"
  zgem add "$ZSH_MODUELS_DIR/osx.zsh"
  # zgem add "$ZSH_MODUELS_DIR/pane.zsh"
  zgem add "$ZSH_MODUELS_DIR/process.zsh"
  zgem add "$ZSH_MODUELS_DIR/prompt.zsh"
  zgem add "$ZSH_MODUELS_DIR/random.zsh"
  zgem add "$ZSH_MODUELS_DIR/ssh.zsh"
  zgem add "$ZSH_MODUELS_DIR/sudo.zsh"
  zgem add "$ZSH_MODUELS_DIR/which.zsh"
}

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


####################### zprofile ######################

function zprofile { 
  (zprofile::active true; zsh -ic exit)
}

function zprofile::active { 
  local value="$1"
  if [ -z "$value" ]; then
    ${ZPROFILE:-false}
  else
    export ZPROFILE="$value"
  fi
}

function zprofile::before { 
  
  PS4=$'%D{%M%S%.} %N:%i> '
  startlog_file=/tmp/startlog.$$
  exec 3>&2 2>$startlog_file
  zmodload 'zsh/zprof';
  
  trap 'setopt xtrace prompt_subst' EXIT
}

function zprofile::after { 
  zprof 
  unsetopt xtrace
  exec 2>&3 3>&-
  cat $startlog_file  | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>3) color=red; else if ($1>=2) color=yellow; else if ($1>=1) color=green; else color=default; printf color; printf "%s", $0; print default}'
  
  trap 'unsetopt xtrace' EXIT
}


##################  Run  ##################

zprofile::active && zprofile::before
zconfig::load
zprofile::active && zprofile::after

