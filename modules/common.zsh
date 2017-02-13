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
