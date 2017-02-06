####################### zconfig ######################
export ZCONFIG_DIR="$(dirname $0)"

#### load zprofile plugin [lazy]
export ZPROFILE="${ZPROFILE:-false}"
function zprofile { source "$ZCONFIG_DIR/plugins/zprofile.zsh"; zprofile $@; }
if ${ZPROFILE}; then source "$ZCONFIG_DIR/plugins/zprofile.zsh"; fi
if ${ZPROFILE}; then zprofile::before; fi

#### load zgem extension manager
# export ZGEM_VERBOSE='true'
source "$ZCONFIG_DIR/plugins/zgem.zsh"

################
### CLI
################
bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

################
### MISC
################

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

export fpath=($fpath "./functions")

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# defaut editor
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

# colorize file system completion
export LSCOLORS="Exfxcxdxbxegedabagacad" # used by ls mac
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" # used by common ls and completion

################
### EXTENSIONS
################

############# load async plugin
source "$ZCONFIG_DIR/plugins/async.zsh"
async_init
async_start_worker 'eval_worker'
function eval_callback { eval "$3"; }
async_register_callback 'eval_worker' 'eval_callback'
function async { async_job 'eval_worker' "echo '$@'"; }
##############

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

zgem add "$ZCONFIG_DIR/modules/color.zsh"
zgem add "$ZCONFIG_DIR/modules/prompt.zsh"
zgem add "$ZCONFIG_DIR/modules/completion.zsh"
zgem add "$ZCONFIG_DIR/modules/history.zsh"

zgem add "$ZCONFIG_DIR/modules/which.zsh"
zgem add "$ZCONFIG_DIR/modules/man.zsh"
#zgem add "$ZCONFIG_DIR/modules/diff.zsh"
#zgem add "$ZCONFIG_DIR/modules/find.zsh"
#zgem add "$ZCONFIG_DIR/modules/network.zsh"
#zgem add "$ZCONFIG_DIR/modules/process.zsh"
#zgem add "$ZCONFIG_DIR/modules/ssh.zsh"
#zgem add "$ZCONFIG_DIR/modules/sudo.zsh"

#zgem add "$ZCONFIG_DIR/modules/git.zsh"
#zgem add "$ZCONFIG_DIR/modules/pane.zsh"
#zgem add "$ZCONFIG_DIR/modules/docker.zsh"
#zgem add "$ZCONFIG_DIR/modules/http-server.zsh"
#zgem add "$ZCONFIG_DIR/modules/maven.zsh"
#zgem add "$ZCONFIG_DIR/modules/osx.zsh"

zgem add "$ZCONFIG_DIR/modules/alias.zsh"

####################### functions ######################

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

if ${ZPROFILE}; then zprofile::after; fi
