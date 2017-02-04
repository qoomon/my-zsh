####################### zprofile ######################

function zprofile {
  local cmd=''
  if [[ "$1" != \-* ]]; then
    cmd="$1"
    [ $# -ge 1 ] && shift
  fi

  case "$cmd" in
    '');
      zprofile::profile $@
      ;;
    'benchmark')
      zprofile::benchmark
      ;;
    *)
      zprofile::debug $cmd $@
      ;;
  esac
}

function zprofile::debug {
  (set -x; $@)
}

function zprofile::benchmark {
  local repeatCount=${1:-10}
  repeat $repeatCount time zsh -ic 'exit 0'
}

function zprofile::profile {
  local verbose='false'
  if [ "$1" = "-v" ]; then
    verbose='true'
  fi
  (zprofile::active true; export ZPROFILE_VERBOSE="$verbose"; zsh -ic 'exit 0')
}

function zprofile::active {
  local value="$1"
  if [ -z "$value" ]; then
    ${ZPROFILE:-false}
  else
    export ZPROFILE="$value"
  fi
}

function zprofile::before {
  if $ZPROFILE_VERBOSE; then
    PS4=$'%D{%M%S%.} %N:%i> '
    startlog_file=/tmp/startlog.$$
    exec 3>&2 2>$startlog_file
    trap 'setopt xtrace prompt_subst' EXIT
  else
    zmodload 'zsh/zprof';
  fi
}

function zprofile::after {
  if $ZPROFILE_VERBOSE; then
    unsetopt xtrace
    exec 2>&3 3>&-
    echo " "
    echo "[zprofile] Press ENTER to print command log..." && read
    cat $startlog_file  | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>3) color=red; else if ($1>=2) color=yellow; else if ($1>=1) color=green; else color=default; printf color; printf "%s", $0; print default}'
  else
    zprof
  fi
}
