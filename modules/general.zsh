autoload +X -U colors && colors

autoload +X -U keeper

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

### MISC
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# defaut editor
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

# colorize file system view
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" 
# for macOS
export LSCOLORS="Exfxcxdxbxegedabagacad" 

# support colors in less
LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
LESS_TERMCAP_ue=$(printf "$reset_color")

setopt MULTIOS  # enable multi output streams
setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt INTERACTIVE_COMMENTS # Allowes to use #-sign as comment within commandline

WORDCHARS='' # threat every special charater as word delimiter
### General Keybindings ###
bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

### fzf configuration
if [ $commands[fd] ]; then
  export FZF_DEFAULT_OPTS='
    --color fg:-1,bg:-1,hl:5,fg+:3,bg+:-1,hl+:5
    --color info:42,prompt:-1,spinner:42,pointer:51,marker:33
    --exact
    --ansi
  '
  export FZF_DEFAULT_COMMAND="fd -c always"
fi