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

## load colors for bash
# function colors {
#   declare -a fg
#   declare -a fg_bold
#   declare -a bg
#   declare -a bg_bold
#
#   fg[cyan]="\e[36m"
#   fg_bold[cyan]="\e[01;36m"
#   bg[cyan]="\e[46m"
#   bg_bold[cyan]="\e[01;46m"
#   fg[white]="\e[37m"
#   fg_bold[white]="\e[01;37m"
#   bg[white]="\e[47m"
#   bg_bold[white]="\e[01;47m"
#   fg[yellow]="\e[33m"
#   fg_bold[yellow]="\e[01;33m"
#   bg[yellow]="\e[43m"
#   bg_bold[yellow]="\e[01;43m"
#   fg[magenta]="\e[35m"
#   fg_bold[magenta]="\e[01;35m"
#   bg[magenta]="\e[45m"
#   bg_bold[magenta]="\e[01;45m"
#   fg[black]="\e[30m"
#   fg_bold[black]="\e[01;30m"
#   bg[black]="\e[40m"
#   bg_bold[black]="\e[01;40m"
#   fg[blue]="\e[34m"
#   fg_bold[blue]="\e[01;34m"
#   bg[blue]="\e[44m"
#   bg_bold[blue]="\e[01;44m"
#   fg[red]="\e[31m"
#   fg_bold[red]="\e[01;31m"
#   bg[red]="\e[41m"
#   bg_bold[red]="\e[01;41m"
#   fg[default]="\e[39m"
#   fg_bold[default]="\e[01;39m"
#   bg[default]="\e[49m"
#   bg_bold[default]="\e[01;49m"
#   fg[grey]="\e[30m"
#   fg_bold[grey]="\e[01;30m"
#   bg[grey]="\e[40m"
#   bg_bold[grey]="\e[01;40m"
#   fg[green]="\e[32m"
#   fg_bold[green]="\e[01;32m"
#   bg[green]="\e[42m"
#   bg_bold[green]="\e[01;42m"
# }
