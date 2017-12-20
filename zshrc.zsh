##### load extension manager
export ZCONFIG_HOME="$(dirname "$0")"
export ZGEM_HOME="$HOME/.zsh.zgem"
export ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"

test ! -e "$ZGEM_HOME" && git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

# # uncomment to load profiling extension (also see below)
# zgem bundle 'https://github.com/qoomon/zprofile.git' from:'git' use:'zprofile.zsh'
# if zprofile::active; then zprofile::before; fi

##### load bundles

zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git' from:'git' use:'zsh-syntax-highlighting.zsh'
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git' from:'git' use:'zsh-history-substring-search.zsh'  # origin 'https://github.com/zsh-users/zsh-history-substring-search.git'
zgem bundle 'https://github.com/zsh-users/zsh-completions.git' from:'git' use:'zsh-completions.plugin.zsh'
zgem bundle 'https://github.com/qoomon/zsh-jumper.git' from:'git' use:'jumper.zsh'

zgem bundle "$ZCONFIG_HOME/zconfig.zsh"
zgem bundle "$ZCONFIG_HOME/modules/general.zsh"
zgem bundle "$ZCONFIG_HOME/modules/history.zsh"
zgem bundle "$ZCONFIG_HOME/modules/prompt.zsh"
zgem bundle "$ZCONFIG_HOME/modules/completion.zsh"
zgem bundle "$ZCONFIG_HOME/modules/alias.zsh"

# # uncomment to load profiling extension
# if zprofile::active; then zprofile::after; fi




