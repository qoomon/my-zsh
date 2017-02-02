####################### zprofile ######################

function zprofile { 
  (zprofile::active true; zsh -ic exit)
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
  
  PS4=$'%D{%M%S%.} %N:%i> '
  startlog_file=/tmp/startlog.$$
  exec 3>&2 2>$startlog_file
  zmodload 'zsh/zprof';
  
  trap 'setopt xtrace prompt_subst' EXIT
}

function zprofile::after { 
  zprof 
  unsetopt xtrace
  exec 2>&3 3>&-
  cat $startlog_file  | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>3) color=red; else if ($1>=2) color=yellow; else if ($1>=1) color=green; else color=default; printf color; printf "%s", $0; print default}'
  
  trap 'unsetopt xtrace' EXIT
}