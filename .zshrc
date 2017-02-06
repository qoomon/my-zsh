####################### zconfig ######################
cd "$(dirname $0)"

source "./zprofile.zsh"

#export ZGEM_VERBOSE='true'
source "./zgem.zsh"  # load zgem extension manager

export ZCONFIG_DIR="."
#export ZCONFIG_VERBOSE='true'
source "./zconfig.zsh"

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

zgem add "./modules/color.zsh"
zgem add "./modules/build-in-extension.zsh"

zgem add "./modules/history.zsh"
zgem add "./modules/completion.zsh"
zgem add "./modules/prompt.zsh"

zgem add "./modules/man.zsh"
zgem add "./modules/diff.zsh" 
#zgem add "./modules/find.zsh" 
zgem add "./modules/network.zsh"
zgem add "./modules/process.zsh" 
#zgem add "./modules/ssh.zsh" 
#zgem add "./modules/sudo.zsh" 

#zgem add "./modules/git.zsh"
#zgem add "./modules/pane.zsh"
#zgem add "./modules/docker.zsh"
zgem add "./modules/http-server.zsh"
zgem add "./modules/maven.zsh" 
#zgem add "./modules/osx.zsh" 

zgem add "./modules/alias.zsh"

if zprofile::active; then zprofile::after; fi
