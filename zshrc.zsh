### load zgem plugin manager
ZGEM_HOME="$HOME/.zsh.zgem"
[[ -e "$ZGEM_HOME" ]] || git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

### Load Config Management
zgem bundle 'https://github.com/qoomon/zconfig.git'
ZCONFIG_HOME=$(dirname $0)
ZCONFIG_UPDATE_COMMAND="git pull; zgem upgrade"

### Add Commands Directory To Path
path=("$ZCONFIG_HOME/commands" $path)

### Set Utils Directory for ZGEM
ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"

### Load Modules
source "$ZCONFIG_HOME/modules/general.zsh"
source "$ZCONFIG_HOME/modules/history.zsh"
source "$ZCONFIG_HOME/modules/completion.zsh"
source "$ZCONFIG_HOME/modules/plugins.zsh"
