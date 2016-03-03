autoload +X -U colors && colors

function mvn_colorized {  
  local opt="\{0,1\}"
  'mvn' $@ | sed \
      -e "s|^\(\[INFO\] Building \)\([^ ]*\)\( [^ ]*\)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[white]}\3$reset_color|" \
      -e "s|^\(\[INFO\] \)\(--- \)\(.*\)|${fg_bold[blue]}\1${fg_no_bold[grey]}\2${fg_no_bold[cyan]}\3$reset_color|" \
      -e "s|^\(\[WARNING\] .*\))|${fg_bold[yellow]}\1$reset_color|" \
      -e "s|^\(\[ERROR\] .*\)|${fg_bold[red]}\1$reset_color|" \
      -e "s|^\(-----.*\)|${fg_bold[white]}\1$reset_color|" \
      -e "s|^\( ${opt}T E S T S\)|${fg_bold[blue]}\1$reset_color|" \
      -e "s|^\(Running \)\(.*\)|${fg_bold[white]}\1${fg_bold[cyan]}\2$reset_color|" \
      -e "s|^\(Results :\)|${fg_bold[white]}\1$reset_color|" \
      -e "s|^\(Tests run: \)\(.*\)\(, Failures: \)\(.*\)\(, Errors: \)\(.*\)\(, Skipped: \)\([^,]*\)\(, .*\)${opt}|${fg_bold[white]}\1${fg_bold[white]}\2${fg_no_bold[white]}\3${fg_no_bold[yellow]}\4${fg_no_bold[white]}\5${fg_bold[red]}\6${fg_no_bold[white]}\7${fg_bold[cyan]}\8${fg_bold[grey]}\9$reset_color|" \
      -e "s|^\(\[INFO\] Installing \)\(.*\)|${fg_bold[blue]}\1${fg_bold[cyan]}\2$reset_color|" \
      -e "s|^\(\[INFO\] \)\([^ ]* \)\(\.*\)\( SUCCESS\)\( \[.*\]\)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[green]}\4${fg_bold[grey]}\5$reset_color|" \
      -e "s|^\(\[INFO\] \)\([^ ]* \)\(\.*\)\( FAILURE\)\( \[.*\]\)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[red]}\4${fg_bold[grey]}\5$reset_color|" \
      -e "s|^\(\[INFO\] \)\([^ ]* \)\(\.*\)\( SKIPPED\)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[blue]}\4$reset_color|" \
      -e "s|^\(\[INFO\] \)\(BUILD SUCCESS.*\)|${fg_bold[blue]}\1${fg_bold[green]}\2$reset_color|" \
      -e "s|^\(\[INFO\] \)\(BUILD FAILURE.*\)|${fg_bold[blue]}\1${fg_bold[red]}\2$reset_color|" \
      -e "s|^\(.*\)|${fg_no_bold[grey]}\1$reset_color|" \
      -l
  return $PIPESTATUS
}
