################
### ALIASES
################

autoload +X -U colors && colors

alias sush="sudo $SHELL"
alias home="cd $HOME"
alias j="jump"

alias preview='() { qlmanage -p $@ &>/dev/null}'

alias type="'type' -a"

alias pick='fzf -m --ansi' # fuzzy search and select anything

alias mv='command mv -i' # ask before overwrite file
alias cp='command cp -i' # ask before overwrite file
alias rm='command rm -i' # ask before remove file

alias ls='command ls -G' # G - colorize types,
alias lsx='ls -lhTA' # l - long format, h - human readable, A - list all except . and ..
# CLICOLOR_FORCE=1 ls -al | fzf --ansi

alias gls='command gls --color'
alias glsx='gls --group-directories-first --time-style=+"%b %d %Y %H:%M:%S" --human-readable -l' # l - long format

alias grep='command grep --color=auto' # colorize matching parts
alias less='command less -R -M -X' # -R : enable colors, -M : shows more detailed prompt, including file position -N : shows line number -X : supresses the terminal clearing at exit

alias aliasx='alias_colorized'

alias mvnx='mvn_colorized'
alias gourcex='gource --time-scale 2.0 --file-idle-time 0 --seconds-per-day 5 --auto-skip-seconds 1 --camera-mode overview --bloom-multiplier 2.0 --bloom-intensity 0.1 --multi-sampling'

alias http-server='command http-server -p 8080 -o'
# alias http-server='docker run --rm --name nginx-volatile -v "$PWD":/usr/share/nginx/html:ro -p 80:80 nginx'
alias http-server-ssl="command http-server -p 8443 -o --ssl --cert $ZSH_FILE_DIR/localhost.pem --key $ZSH_FILE_DIR/localhost.pem"
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
