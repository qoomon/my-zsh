function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1 ${fg[white]}###\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion

################
### ALIASES
################

alias aliasx=alias_colorized

alias type="type -a"

alias pick='\fzf -m ' # fuzzy search and select anything

alias mv='\mv -i' # ask before overwrite file
alias cp='\cp -i' # ask before overwrite file
alias rm='\rm -i' # ask before remove file

alias ls='\ls -G' # G - colorize types,
alias lsx='ls -lhTA' # l - long format, h - human readable, A - list all except . and ..

alias gls='\gls --color'
alias glsx='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='\grep --color=auto' # colorize matching parts
alias less='\less -R' # enable colors

alias mvnx='mvn_colorized'

alias man='man_colorized'

alias diff='diff_colorized'

alias wordcount="tr -s ' ' | tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr"

alias debug_function='() { (set -x; $@) } '

alias devide='_print_divider'


################
### SUFFIX ALIASES
################
# alias -s jpeg="open"


################
### CLI
################
bindkey -e # -e emacs mode -v for vi mode
bindkey '^[^[[D' backward-word # alt + left
bindkey '^[^[[C' forward-word  # alt + rigth

type hh >/dev/null && bindkey -s "^R" "hh\n" # Ctrl + r; overide default hisory search with hh if installed

################
### MISC
################

# defaut editor
export VISUAL='vim'
export EDITOR='vim'

# colorize file system completion
export LSCOLORS="Exfxcxdxbxegedabagacad" # used by ls mac
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" # used by common ls and completion
