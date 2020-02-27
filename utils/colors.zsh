autoload -Uz colors && colors

#print all default colors
function colors-ls {
  for k in "${(@k)fg}"; do
    echo "${fg[$k]}\${fg[$k]}$reset_color"
    echo "${fg_bold[$k]}\${fg_bold[$k]}$reset_color"
    echo "${bg[$k]}\${bg[$k]}$reset_color"
    echo "${bg_bold[$k]}\${bg_bold[$k]}$reset_color"
  done
}
