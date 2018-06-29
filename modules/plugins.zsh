### zsh-syntax-highlighting Config ###
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=300

### history-substring-search Config ###
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY='true'
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  bindkey '^[[A' history-substring-search-up     # arrow-up
  bindkey '^[[B' history-substring-search-down   # arrow-down
else
  bindkey "${terminfo[kcuu1]}" history-substring-search-up     # arrow-up
  bindkey "${terminfo[kcud1]}" history-substring-search-down   # arrow-down
fi

### zsh-history-search Config ###
HISTORY_ARGUMENT_SEARCH_LIMIT=1000
if [ $commands[fzf] ]; then
  zle -N _history_widget
  bindkey '^R' _history_widget
  
  zle -N _history_argument_widget
  bindkey '^@' _history_argument_widget
fi
