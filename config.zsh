
### CLI

bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

### MISC

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


### EXTENSIONS

zgem add 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem add 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
  bindkey '^[[A' history-substring-search-up     # bind arrow-up
  bindkey '^[[B' history-substring-search-down   # bind arrow-down
zgem add "$ZCONFIG_DIR/modules/history.zsh"
zgem add "$ZCONFIG_DIR/modules/prompt.zsh"

async zgem add 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
async zgem add 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker' from:'http' as:'completion'
async zgem add 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose' from:'http' as:'completion'
async zgem add "$ZCONFIG_DIR/modules/completion.zsh"

async zgem add 'https://github.com/rupa/z.git' from:'git' use:'z.sh'

async zgem add "$ZCONFIG_DIR/modules/color.zsh"
async zgem add "$ZCONFIG_DIR/modules/which.zsh"
async zgem add "$ZCONFIG_DIR/modules/man.zsh"
async zgem add "$ZCONFIG_DIR/modules/diff.zsh"
async zgem add "$ZCONFIG_DIR/modules/find.zsh"
async zgem add "$ZCONFIG_DIR/modules/network.zsh"
async zgem add "$ZCONFIG_DIR/modules/process.zsh"
async zgem add "$ZCONFIG_DIR/modules/ssh.zsh"
async zgem add "$ZCONFIG_DIR/modules/sudo.zsh"

async zgem add "$ZCONFIG_DIR/modules/git.zsh"
async zgem add "$ZCONFIG_DIR/modules/pane.zsh"
async zgem add "$ZCONFIG_DIR/modules/docker.zsh"
async zgem add "$ZCONFIG_DIR/modules/http-server.zsh"
async zgem add "$ZCONFIG_DIR/modules/maven.zsh"
async zgem add "$ZCONFIG_DIR/modules/osx.zsh"

async zgem add "$ZCONFIG_DIR/modules/alias.zsh"

