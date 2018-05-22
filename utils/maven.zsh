autoload +X -U colors && colors

function mvn-colorized {
  'mvn' $@ | sed -E \
      -e "s|^(\[INFO\] Building )([^ ]*)( .*)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[white]}\3$reset_color|" \
      -e "s|^(\[INFO\] )(--- )(.*)|${fg_bold[blue]}\1${fg_no_bold[grey]}\2${fg_no_bold[cyan]}\3$reset_color|" \
      -e "s|^(\[WARNING\] .*)|${fg_bold[yellow]}\1$reset_color|" \
      -e "s|^(\[ERROR\] .*)|${fg_bold[red]}\1$reset_color|" \
      -e "s|^(-----.*)|${fg_bold[white]}\1$reset_color|" \
      -e "s|^( ?T E S T S)|${fg_bold[blue]}\1$reset_color|" \
      -e "s|^(Running )(.*)|${fg_bold[white]}\1${fg_bold[cyan]}\2$reset_color|" \
      -e "s|^(Results :)|${fg_bold[white]}\1$reset_color|" \
      -e "s|^(Tests run: [0-9]*, )(Failures: 0, Errors: 0, Skipped: 0,? ?)(.*)|${fg_bold[green]}\1${fg_bold[white]}\2\3$reset_color|" \
      -e "s|^(Tests run: [0-9]*, )(.*)((Failures: 0, )\|(Failures: [0-9]*, ))(.*)|\1\2\4${fg_bold[yellow]}\5${fg_bold[white]}\6$reset_color|" \
      -e "s|^(Tests run: [0-9]*, )(.*)((Errors: 0, )\|(Errors: [0-9]*, ))(.*)|\1\2\4${fg_bold[red]}\5${fg_bold[white]}\6$reset_color|" \
      -e "s|^(Tests run: [0-9]*, )(.*)((Skipped: 0,? ?)\|(Skipped: [0-9]*,? ?))(.*)|\1\2\4${fg_bold[blue]}\5${fg_bold[white]}\6$reset_color|" \
      -e "s|^(Tests run: [0-9]*, )(.*)|${fg_bold[white]}\1\2$reset_color|" \
      -e "s|^(\[INFO\] Installing )(.*)|${fg_bold[blue]}\1${fg_bold[cyan]}\2$reset_color|" \
      -e "s|^(\[INFO\] )([^ ]* )(\.*)( SUCCESS)( \[.*\])|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[green]}\4${fg_bold[grey]}\5$reset_color|" \
      -e "s|^(\[INFO\] )([^ ]* )(\.*)( FAILURE)( \[.*\])|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[red]}\4${fg_bold[grey]}\5$reset_color|" \
      -e "s|^(\[INFO\] )([^ ]* )(\.*)( SKIPPED)|${fg_bold[blue]}\1${fg_bold[cyan]}\2${fg_bold[grey]}\3${fg_bold[blue]}\4$reset_color|" \
      -e "s|^(\[INFO\] )(BUILD SUCCESS.*)|${fg_bold[blue]}\1${fg_bold[green]}\2$reset_color|" \
      -e "s|^(\[INFO\] )(BUILD FAILURE.*)|${fg_bold[blue]}\1${fg_bold[red]}\2$reset_color|" \
      -e "s|^(.*)|${fg_bold[grey]}\1$reset_color|" \
      -l
  return ${pipestatus[1]}
}

compdef _mvn mvn_colorized # set default completion

function mvn-project-version {
  'mvn' exec:exec -Dexec.executable='echo' -Dexec.args='${project.version}' --quiet --non-recursive
}