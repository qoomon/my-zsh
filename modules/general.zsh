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

setopt multios  # enable multi output streams

WORDCHARS='' # threat every special charater as word delimiter
### General Keybindings ###
bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

### mvn
MAVEN_OPTS='-XX:+TieredCompilation -XX:TieredStopAtLevel=1' # speedup maven builds

### util function that execute given commad in every sub directory
function workspace {
  WORKSPACE=$PWD; 
  CMD="$@"; 
  for dir in */; do 
    ( cd $dir && printf "\\e[34m${PWD#$WORKSPACE/}:\\e[39m\\n" && eval $CMD && echo )
  done
}

### fzf configuration
export FZF_DEFAULT_OPTS='
  --color fg:-1,bg:-1,hl:5,fg+:3,bg+:-1,hl+:5
  --color info:42,prompt:-1,spinner:42,pointer:51,marker:33
  --exact
'
if [ $commands[fd] ]; then
  export FZF_DEFAULT_COMMAND="fd"
fi
  
