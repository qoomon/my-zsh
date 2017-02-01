################ PROFILING ZSHRC FILE - load profiler
function zshrc_profile { (export ZSH_PROFILE='yes'; zsh -ic exit)}
ZSH_PROFILE=${ZSH_PROFILE:-'no'}
if [ "$ZSH_PROFILE" = 'yes' ]; then
  PS4=$'%D{%M%S%.} %N:%i> '
  startlog_file=/tmp/startlog.$$
  exec 3>&2 2>$startlog_file
  setopt xtrace prompt_subst
  zmodload 'zsh/zprof';
fi

################
### LOAD ORGANIZER
################

export ZSH_CONFIG_DIR=$(dirname $0)
source "$ZSH_CONFIG_DIR/zsh_organizer.zsh"

################
### LOAD SOURCES
################

zsh_bundle_plugin 'https://github.com/rupa/z.git' 'z.sh'
# zsh_bundle_plugin 'https://github.com/jimhester/per-directory-history'
zsh_bundle_plugin 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
zsh_bundle_plugin 'https://github.com/zsh-users/zsh-history-substring-search.git'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
  bindkey '^[[A' history-substring-search-up     # bind arrow-up
  bindkey '^[[B' history-substring-search-down   # bind arrow-down
zsh_bundle_plugin 'https://github.com/zsh-users/zsh-completions.git'

zsh_bundle_completion 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker'
zsh_bundle_completion 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose'

zsh_bundle_module 'basic'
zsh_bundle_module 'color'

zsh_bundle_module 'benchmark'
zsh_bundle_module 'completion'
zsh_bundle_module 'diff'
zsh_bundle_module 'docker'
zsh_bundle_module 'find'
# zsh_bundle_module 'git'
zsh_bundle_module 'history'
zsh_bundle_module 'http-server'
zsh_bundle_module 'man'
zsh_bundle_module 'maven'
zsh_bundle_module 'network'
zsh_bundle_module 'osx'
# zsh_bundle_module 'pane'
zsh_bundle_module 'process'
zsh_bundle_module 'prompt'
zsh_bundle_module 'random'
zsh_bundle_module 'ssh'
zsh_bundle_module 'sudo'
zsh_bundle_module 'which'

################ PROFILING ZSHRC FILE - print results
if [ "$ZSH_PROFILE" = 'yes' ]; then
  zprof
  unsetopt xtrace
  exec 2>&3 3>&-
  cat $startlog_file  | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>3) color=red; else if ($1>=2) color=yellow; else if ($1>=1) color=green; else color=default; printf color; printf "%s", $0; print default}'
fi
