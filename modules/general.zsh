autoload -U colors && colors
autoload -U keeper

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# defaut editor
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

# colorize file system view
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" 
# colorize file system view (macOS)
export LSCOLORS="Exfxcxdxbxegedabagacad" 

# support colors in less
export LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
export LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
export LESS_TERMCAP_ue=$(printf "$reset_color")

setopt MULTIOS  # enable multi output streams
setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt INTERACTIVE_COMMENTS # Allowes to use #-sign as comment within commandline
export WORDCHARS='' # threat every special charater as word delimiter

### General Keybindings ###
bindkey '^[b' backward-word # alt + left
bindkey "^[f" forward-word # alt + rigth

# Enable math functions e.g. (( f = sin(0.3) ))
zmodload zsh/mathfunc

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Undo aborted command line
function zle-line-init {
 if [[ -n $ZLE_LINE_ABORTED ]]; then
   local buffer_save="$BUFFER"
   local cursor_save="$CURSOR"
   BUFFER="$ZLE_LINE_ABORTED" 
   CURSOR="${#BUFFER}" 
   zle split-undo
   BUFFER="$buffer_save" CURSOR="$cursor_save" 
 fi
}
zle -N zle-line-init

### fzf configuration
if [ $commands[fzf] ]; then
  export FZF_DEFAULT_OPTS='
    --color fg:-1,bg:-1,hl:5,fg+:3,bg+:-1,hl+:5
    --color info:42,prompt:-1,spinner:42,pointer:51,marker:33
    --exact
    --ansi
  '
  if [ $commands[fd] ]; then
    export FZF_DEFAULT_COMMAND="fd -c always"
  fi
fi
