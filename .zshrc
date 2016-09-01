################ PROFILING ZSHRC FILE - load profiler
ZSH_PROFILE=${ZSH_PROFILE:-'no'}
[ "$ZSH_PROFILE" = 'yes' ] && zmodload 'zsh/zprof';
function zshrc_profile { (export ZSH_PROFILE='yes'; time (zsh -ic exit)) }

################
### SETUP
################
export ZDOTDIR=${ZDOTDIR:-$HOME}

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
### LOAD MODULES
################
zsh_module_bundle 'basic'
if [ "$ZSH_UI" = 'yes' ]; then
  zsh_module_bundle 'prompt'
  zsh_module_bundle 'completion'
  zsh_module_bundle 'history'
fi

zsh_module_bundle

zsh_functions_load

################
### LOAD EXTERNAL RESOURCES
################
if [ "$ZSH_UI" = 'yes' ]; then
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

################ PROFILING ZSHRC FILE - print results
[ "$ZSH_PROFILE" = 'yes' ] && zprof