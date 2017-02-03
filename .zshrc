####################### zconfig ######################

export SELF_DIR="$(dirname $0)"
#export ZGEM_VERBOSE='true'
#export ZCONFIG_VERBOSE='true'

source "$SELF_DIR/zprofile.zsh"

if zprofile::active; then zprofile::before; fi

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

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# defaut editor
export VISUAL='vim'
export EDITOR='vim'

# colorize file system completion
export LSCOLORS="Exfxcxdxbxegedabagacad" # used by ls mac
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" # used by common ls and completion

################
### EXTENSIONS
################

source "$SELF_DIR/zgem.zsh"  # load zgem extension manager

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

zgem add "$SELF_DIR/modules/color.zsh"
zgem add "$SELF_DIR/modules/build-in-extension.zsh"

zgem add "$SELF_DIR/modules/history.zsh"
zgem add "$SELF_DIR/modules/completion.zsh"
zgem add "$SELF_DIR/modules/prompt.zsh"

zgem add "$SELF_DIR/modules/man.zsh" lazy:'man_colorized'
zgem add "$SELF_DIR/modules/diff.zsh" lazy:'diff_colorized'
zgem add "$SELF_DIR/modules/find.zsh" lazy:'find_ls'
zgem add "$SELF_DIR/modules/network.zsh" lazy:'ip_internal, ip_external'
zgem add "$SELF_DIR/modules/process.zsh" lazy:'pid, limits'
#zgem add "$SELF_DIR/modules/ssh.zsh" lazy:'ssh_tunnel, ssh_key_set, ssh_key_info'
zgem add "$SELF_DIR/modules/sudo.zsh" lazy:'sudome'

#zgem add "$SELF_DIR/modules/git.zsh"
#zgem add "$SELF_DIR/modules/pane.zsh"
#zgem add "$SELF_DIR/modules/docker.zsh" lazy:'docker_connect, docker_registry_image_tags'
zgem add "$SELF_DIR/modules/http-server.zsh"
zgem add "$SELF_DIR/modules/maven.zsh" lazy:'mvn_colorized, mvn_project_version, mvn_project_version_all'
#zgem add "$SELF_DIR/modules/osx.zsh" lazy:'notify, man_preview'

zgem add "$SELF_DIR/modules/alias.zsh"

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
    'reload')
      zconfig::reload
      ;;
    'profile')
      zprofile
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
  $editor "$SELF_DIR"
}

function zconfig::update {
  echo "${fg_bold[blue]}[zconfig]${reset_color}" "${fg_bold[blue]}home directory${reset_color} $SELF_DIR"
  (cd $SELF_DIR; git pull)
}

function zconfig::reload {
  exec "$SHELL" -l
}
