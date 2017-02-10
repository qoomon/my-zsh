### CLI

bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

### MISC

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# defaut editor
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

# colorize file system completion
export LSCOLORS="Exfxcxdxbxegedabagacad" # used by ls mac
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" # used by common ls and completion

# support colors in less
LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
LESS_TERMCAP_ue=$(printf "$reset_color")