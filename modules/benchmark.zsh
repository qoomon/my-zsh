function zshrc_benchmark {
  local repeatCount=${1:-10}
  repeat $repeatCount time zsh -ic exit
}

function zshrc_profile {
  (export ZSH_PROFILE='yes'; zsh -ic exit)
}
# zmodload -a zsh/zprof;
# source .zshrc
# zprof
# <DOING THINGS>
# zmodload zsh/datetime
# echo $EPOCHREALTIME



# PS4=$'%D{%M%S%.} %N:%i> '
# local startlog_file=$HOME/tmp/startlog.$$
# exec 3>&2 2>$startlog_file
# setopt xtrace prompt_subst
# <DOING THINGS>
# unsetopt xtrace
# exec 2>&3 3>&-
# cat $startlog_file | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>10) color=red; else if ($1>=5) color=yellow; else if ($1>0) color=green; else color=default; printf color; printf "%s", $0; print default}'