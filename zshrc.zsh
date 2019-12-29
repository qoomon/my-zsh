export ZCONFIG_HOME=$(dirname "$0")

### load zgem plugin manager
export ZGEM_HOME="$HOME/.zgem"
export ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"
if [ ! -e "$ZGEM_HOME" ]; then git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"; fi
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

zgem bundle "$ZCONFIG_HOME/utils/zconfig.zsh"
export ZCONFIG_UPDATE_COMMAND="(cd '$ZCONFIG_HOME'; git pull); zgem upgrade"

### modules
zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

zgem bundle "$ZCONFIG_HOME/modules/plugins.zsh"

### utils
zgem bundle "$ZCONFIG_HOME/utils/command-line.zsh"
zgem bundle "$ZCONFIG_HOME/utils/ssh.zsh"
