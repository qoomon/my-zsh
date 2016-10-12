################ PROFILING ZSHRC FILE - load profiler
ZSH_PROFILE=${ZSH_PROFILE:-'no'}
if [ "$ZSH_PROFILE" = 'yes' ]; then
  PS4=$'%D{%M%S%.} %N:%i> '
  startlog_file=/tmp/startlog.$$
  exec 3>&2 2>$startlog_file
  setopt xtrace prompt_subst

  zmodload 'zsh/zprof';
fi
function zshrc_profile { time (export ZSH_PROFILE='yes';  zsh -ic exit) }

################
### SETUP
################

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export ZSH_UI=${ZSH_UI:-'yes'}

################
### PATH
################
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

################
### LOAD ORGANIZER
################

export ZSH_CONFIG_DIR=$(dirname $0)
source "$ZSH_CONFIG_DIR/zsh_organizer.zsh"

################
### LOAD EXTERNAL RESOURCES
################
if [ "$ZSH_UI" = 'yes' ]; then
  # zsh_plugin_bundle 'https://github.com/rupa/z.git' 'z.sh'
  # zsh_plugin_bundle 'https://github.com/jimhester/per-directory-history'
  zsh_plugin_bundle 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
  zsh_plugin_bundle 'https://github.com/zsh-users/zsh-history-substring-search.git'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=black,bold'
    HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
    bindkey '^[[A' history-substring-search-up     # bind arrow-up
    bindkey '^[[B' history-substring-search-down   # bind arrow-down
  zsh_plugin_bundle 'https://github.com/zsh-users/zsh-completions.git'
  zsh_completion_bundle 'https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker'
  zsh_completion_bundle 'https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose'
fi

################
### LOAD MODULES
################
zsh_module_bundle 'basic'
if [ "$ZSH_UI" = 'yes' ]; then
  zsh_module_bundle 'prompt'
  zsh_module_bundle 'completion'
  zsh_module_bundle 'history'
fi

zsh_module_bundle_all

################
### LOAD FUNCTIONS
################

zsh_function_bundle_all

################ PROFILING ZSHRC FILE - print results
if [ "$ZSH_PROFILE" = 'yes' ]; then
  zprof

  unsetopt xtrace
  exec 2>&3 3>&-
  cat $startlog_file  | awk 'p{printf "%3s", $1-p ;printf " "; $1=""; print $0}{p=$1}' | awk -v red="$(tput setaf 1)" -v yellow="$(tput setaf 3)" -v green="$(tput setaf 2)" -v default="$(tput sgr0)" '{if ($1>3) color=red; else if ($1>=2) color=yellow; else if ($1>=1) color=green; else color=default; printf color; printf "%s", $0; print default}'
fi
