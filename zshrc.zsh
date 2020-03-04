cd $(dirname "$0")

### load zgem plugin manager
export ZGEM_HOME="$HOME/.zgem"
export ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"
if [[ ! -e "$ZGEM_HOME" ]] git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

### modules
source "modules/general.zsh"
source "modules/history.zsh"
source "modules/completion.zsh"
source "modules/alias.zsh"

source "modules/plugins.zsh"

export ZCONFIG_UPDATE_COMMAND="(cd '$PWD'; git pull); zgem upgrade"
source "zconfig.zsh"

export PATH="$PWD/commands:$PATH"
