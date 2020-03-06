### load zgem plugin manager
ZGEM_HOME="$HOME/.zgem"
ZGEM_UTILS_DIR="$ZCONFIG_HOME/utils"
if [[ ! -e "$ZGEM_HOME" ]] git clone 'https://github.com/qoomon/zgem.git' "$ZGEM_HOME"
source "$ZGEM_HOME/zgem.zsh" # && ZGEM_VERBOSE='true'

### Load Config Management 
zgem bundle 'zconfig'
ZCONFIG_UPDATE_COMMAND="(cd '$ZCONFIG_HOME'; git pull); zgem upgrade"

################################################################################
zgem bundle 'https://github.com/qoomon/zsh-lazyload.git'

################################################################################
zgem bundle 'https://github.com/qoomon/zsh-theme-qoomon.git' use:'qoomon.zsh-theme'
# TODO fix cancel multiline bug e.g. git rm <TAB> <ctrl+c>
PROMPT_INFO_HOST='false'

################################################################################
zgem bundle 'https://github.com/qoomon/zjump.git'

################################################################################
zgem bundle 'https://github.com/qoomon/zsh-history-search.git'

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-completions.git'

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=300

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY='true'
bindkey '^[[A' history-substring-search-up                # arrow-up
bindkey '^[[B' history-substring-search-down              # arrow-down
bindkey "$terminfo[kcuu1]" history-substring-search-up    # arrow-up
bindkey "$terminfo[kcud1]" history-substring-search-down  # arrow-down
