### Plugin Config - zsh-syntax-highlighting ###
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=300

### Plugin Config - history-substring-search ###
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY='true'
# tested with macOS
bindkey '^[[A' history-substring-search-up     # bind arrow-up
bindkey '^[[B' history-substring-search-down   # bind arrow-down
# tested with ubuntu
bindkey '^[OA' history-substring-search-up     # bind arrow-up
bindkey '^[OB' history-substring-search-down   # bind arrow-down

### Plugin Config - zsh-history-search ###
HISTORY_ARGUMENT_SEARCH_LIMIT=1000
if type fzf >/dev/null; then
  zle -N _history_widget
  bindkey '^R' _history_widget
  
  zle -N _history_argument_widget
  bindkey '^@' _history_argument_widget
fi
