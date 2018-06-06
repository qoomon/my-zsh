##### load extension manager
export ZCONFIG_HOME="$(dirname "$0")"
export ZCONFIG_FILE_DIR="$ZCONFIG_HOME/files"
export ZGEM_HOME="$HOME/.zgem"
export ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"

### load zgem plugin manager
if [ ! -e "$ZGEM_HOME" ]; then git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"; fi
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

zgem bundle 'https://github.com/qoomon/zprofile.git' from:'git' use:'zprofile.zsh'
if [ "$ZPROFILE" = 'active' ]; then zprofile::before; fi

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
zgem bundle 'https://github.com/qoomon/zsh-history-search.git' from:'git' use:'zsh-history-search.zsh'
zgem bundle 'https://github.com/qoomon/zjump.git' from:'git' use:'zjump.zsh'

cd $ZCONFIG_HOME
zgem bundle "./zconfig.zsh"
zgem bundle "./modules/general.zsh"
zgem bundle "./modules/history.zsh"
zgem bundle "./modules/prompt.zsh"
zgem bundle "./modules/completion.zsh"
zgem bundle "./modules/alias.zsh"
zgem bundle "./utils/ssh.zsh"
cd - >/dev/null

if [ "$ZPROFILE" = 'active' ] ; then zprofile::after; fi
