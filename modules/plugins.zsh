################################################################################
zgem bundle 'https://github.com/qoomon/zsh-lazyload.git'

################################################################################
zgem bundle 'https://github.com/qoomon/zsh-theme-qoomon.git'
PROMPT_INFO_HOST='false'

################################################################################
zgem bundle 'https://github.com/qoomon/zjump.git'

################################################################################
zgem bundle 'https://github.com/qoomon/zsh-history-search.git'

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-completions.git'

################################################################################
if [ $commands[fzf] ]
then
    zgem bundle 'https://github.com/Aloxaf/fzf-tab.git'
    zstyle ':fzf-tab:*'                 prefix '' # disable prefix for completion matches
    zstyle ':fzf-tab:*'                 switch-group ',' '.' # switch group using `,` and `.`
    zstyle ':fzf-tab:*'                 fzf-flags '--no-mouse' # make completions selectable
    zstyle ':completion:*:descriptions' format $'\e[1m❬%d❭\e[0m' # set descriptions format to enable group support
fi

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=2048

################################################################################
zgem bundle 'https://github.com/zsh-users/zsh-history-substring-search.git'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY='true'

bindkey '^[[A' history-substring-search-up    # arrow-up
bindkey '^[[B' history-substring-search-down  # arrow-down
[ ${key[Up]} ]   && bindkey "${key[Up]}"   history-substring-search-up    # arrow-up
[ ${key[Down]} ] && bindkey "${key[Down]}" history-substring-search-down  # arrow-down
