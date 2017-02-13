################
### ALIASES
################

autoload +X -U colors && colors

alias sush="sudo $SHELL"

alias type="'type' -a"

alias pick='fzf -m ' # fuzzy search and select anything

alias mv='command mv -i' # ask before overwrite file
alias cp='command cp -i' # ask before overwrite file
alias rm='command rm -i' # ask before remove file

alias ls='command ls -G' # G - colorize types,
alias lsx='ls -lhTA' # l - long format, h - human readable, A - list all except . and ..

alias gls='command gls --color'
alias glsx='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='command grep --color=auto' # colorize matching parts
alias less='command less -R -M -X' # -R : enable colors, -M : shows more detailed prompt, including file position -N : shows line number -X : supresses the terminal clearing at exit

alias aliasx='alias_colorized'

alias mvnx='mvn_colorized'

alias man='() {
env \
  LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
  LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
  LESS_TERMCAP_ue=$(printf "$reset_color") \
  PAGER="${commands[less]:-$PAGER}" \
  _NROFF_U=1 \
command man $@
}'

alias diff='() {
command diff $@ | sed \
  -e "s|^\(<.*\)|${fg[red]}\1$reset_color|" \
  -e "s|^\(>.*\)|${fg[green]}\1$reset_color|" \
  -e "s|^\([a-z0-9].*\)|${fg_bold[cyan]}\1$reset_color|" \
  -l
return ${pipestatus[1]}
}'

alias wordcount="tr -s ' ' | tr ' ' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr"

# alias -s jpeg="open" # sufix alias

function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion
