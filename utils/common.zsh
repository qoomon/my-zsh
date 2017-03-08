autoload +X -U colors && colors

#print all default colors
function colors_ls {
  for k in "${(@k)fg}"; do
    echo "${fg[$k]}\${fg[$k]}$reset_color"
    echo "${fg_bold[$k]}\${fg_bold[$k]}$reset_color"
    echo "${bg[$k]}\${bg[$k]}$reset_color"
    echo "${bg_bold[$k]}\${bg_bold[$k]}$reset_color"
  done
}

function calc {
  awk "BEGIN{ print $* }"
  awk '{ sum += $1 } END { print sum }'
}


function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1###${fg[white]}\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion


function man_colorized {
  env \
    LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
    LESS_TERMCAP_us=$(printf "${fg[cyan]}") \
    LESS_TERMCAP_ue=$(printf "$reset_color") \
    PAGER="${commands[less]:-$PAGER}" \
    _NROFF_U=1 \
  'man' $@
}
type compdef >/dev/null && compdef _man man_colorized # set default completion


function diff_colorized {
  local opt="\{0,1\}"
  'diff' $@ | sed \
      -e "s|^\(<.*\)|${fg[red]}\1$reset_color|" \
      -e "s|^\(>.*\)|${fg[green]}\1$reset_color|" \
      -e "s|^\([a-z0-9].*\)|${fg_bold[cyan]}\1$reset_color|" \
      -l
  return ${pipestatus[1]}
}
type compdef >/dev/null && compdef _diff diff_colorized # set default completion


function gauth {
  local secretBase32=$1
  watch -n1 'echo $(oathtool --totp --base32 '$secretBase32') $(expr 30 - $(date +%s) % 30)s'
}
