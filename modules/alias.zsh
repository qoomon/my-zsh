################
### ALIASES
################

autoload +X -U colors && colors

function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion
alias aliasx='alias_colorized'

alias sudo='sudo' # make allias work with sudo
alias sush="sudo $SHELL"

alias cd='j::cd'

alias commands='echo ${commands/%/\\n} | fzf'

alias preview='() { qlmanage -p $@ &>/dev/null}'

alias type='type -a'

alias pick='fzf -m --ansi' # fuzzy search and select anything

alias mv='mv -i' # ask before overwrite file
alias cp='cp -i' # ask before overwrite file
alias rm='rm -i' # ask before remove file

alias ls='ls -G' # G - colorize types,
alias lsx='ls -lhTA' # l - long format, h - human readable, A - list all except . and ..
# CLICOLOR_FORCE=1 ls -al | fzf --ansi

alias gls='gls --color'
alias glsx='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='grep --color=auto' # colorize matching parts
alias less='less -R -M -X' # -R : enable colors, -M : shows more detailed prompt, including file position -N : shows line number -X : supresses the terminal clearing at exit



alias mvnx='mvn_colorized'
alias gourcex='gource --time-scale 2.0 --file-idle-time 0 --seconds-per-day 5 --auto-skip-seconds 1 --camera-mode overview --bloom-multiplier 2.0 --bloom-intensity 0.1 --multi-sampling'

alias http-server='http-server -p 8080 -o'
# alias http-server='docker run --rm --name nginx-volatile -v "$PWD":/usr/share/nginx/html:ro -p 80:80 nginx'
alias http-server-ssl="http-server -p 8443 -o --ssl --cert $ZSH_FILE_DIR/localhost.pem --key $ZSH_FILE_DIR/localhost.pem"
alias https-server='http-server-ssl'

# save pipe output to given variable e.g. echo foo | to bar; echo $bar
alias to='read -r'

alias sum="awk '{ sum += \$1 } END { print sum }'"

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
