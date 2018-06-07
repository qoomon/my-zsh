### load zgem plugin manager
export ZGEM_HOME="$HOME/.zgem"
export ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"
if [ ! -e "$ZGEM_HOME" ]; then git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"; fi
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

##### config utils
export ZCONFIG_HOME="$(dirname "$0")"
export ZCONFIG_UPDATE_COMMANDS='zgem upgrade'
zgem bundle "$ZCONFIG_HOME/utils/zconfig.zsh"

zgem bundle 'https://github.com/qoomon/zprofile.git'
if [ "$ZPROFILE" = 'active' ]; then zprofile::before; fi

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git'
zgem bundle 'https://github.com/zsh-users/zsh-completions.git'
zgem bundle 'https://github.com/qoomon/zsh-history-search.git'
zgem bundle 'https://github.com/qoomon/zjump.git'

zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/plugins.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/prompt.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

zgem bundle "$ZCONFIG_HOME/utils/ssh.zsh"

if [ "$ZPROFILE" = 'active' ] ; then zprofile::after; fi
