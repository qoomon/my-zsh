autoload +X -U colors && colors

function diff_colorized {  
  local opt="\{0,1\}"
  'diff' $@ | sed \
      -e "s|^\(<.*\)|${fg[red]}\1$reset_color|" \
      -e "s|^\(>.*\)|${fg[green]}\1$reset_color|" \
      -e "s|^\([a-z0-9].*\)|${fg_bold[cyan]}\1$reset_color|" \
      -l
  return $PIPESTATUS
}