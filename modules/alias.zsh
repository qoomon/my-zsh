################
### ALIASES
################

autoload +X -U colors && colors

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

alias aliasx='alias_colorized'

alias mvnx='mvn_colorized'

alias man='man_colorized'

alias diff='diff_colorized'

alias wordcount="tr -s ' ' | tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr"

# alias -s jpeg="open" # sufix alias

function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)(=.*)|${fg_bold[blue]}\1${fg[white]}\2$reset_color|" 
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion

