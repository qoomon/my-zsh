################
### ALIASES
################

autoload +X -U colors && colors

alias aliasx="alias | sort | sed -E -e 's|^([^=]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|' | column -s '###' -t"

alias sush="sudo $SHELL"
alias home="cd $HOME"

alias type="'type' -a"

alias pick='fzf -m --ansi' # fuzzy search and select anything

alias mv='command mv -i' # ask before overwrite file
alias cp='command cp -i' # ask before overwrite file
alias rm='command rm -i' # ask before remove file

alias commands='(){command ls -G $@ $commands}'

alias ls='command ls -G' # G - colorize types,
alias lsx='ls -hTAp' # h - human readable, A - list all except . and ..
# CLICOLOR_FORCE=1 ls -al | fzf --ansi

alias gls='command gls --color'
alias glsx='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='command grep --color=auto' # colorize matching parts
alias less='command less -R -M -X' # -R : enable colors, -M : shows more detailed prompt, including file position -N : shows line number -X : supresses the terminal clearing at exit

alias https="http --default-scheme https"

alias http-server='command http-server -a localhost -p 8080'
alias https-server="command http-server -a localhost -p 8443 --ssl --cert $ZCONFIG_FILE_DIR/localhost.crt --key $ZCONFIG_FILE_DIR/localhost.key"

alias pwgen='(){command pwgen -scnyB1 ${1:-20}}'

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
