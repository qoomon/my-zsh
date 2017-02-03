################
### ALIASES
################

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

# alias -s jpeg="open" # sufix alias







