##############################################################################
### Organizer
### - zsh Manager for Plugins, Completions and Modules
##############################################################################
autoload +X -U colors && colors

export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR:-"$HOME"}

export ZSH_MODULE_DIR="$ZSH_CONFIG_DIR/modules"

export ZSH_FUNCTION_DIR="$ZSH_CONFIG_DIR/functions"

export ZSH_LIB_DIR="$ZSH_CONFIG_DIR/lib"

export ZSH_PLUGIN_DIR="$ZSH_LIB_DIR/plugins"

export ZSH_COMPLETION_DIR="$ZSH_LIB_DIR/completion"
fpath=($fpath "$ZSH_COMPLETION_DIR")

export ZSH_FILE_DIR="$ZSH_CONFIG_DIR/files"

function file_basename { 
  local file=$1
  file=${file##*/}; 
  file=${file%%.*}; 
  echo $file
}

function zsh_reload {
  exec "$SHELL" -l
}

function zsh_config_edit {
  atom "$ZSH_CONFIG_DIR"
}

# plugin management
function zsh_config_update {
  # update self
  cd $ZSH_CONFIG_DIR;
  echo "${fg_bold[blue]}* update config $(pwd)$reset_color"
  git pull
  echo " "
  cd - 1> /dev/null

  zsh_plugins_update

  zsh_completions_update

  zsh_reload
}

set -a ZSH_MODULES; ZSH_MODULES=()
function zsh_module_bundle {
  local module_name=$1
  if [ -n "$module_name" ]; then
    if [[ "${ZSH_MODULES[(r)$module_name]}" != "$module_name" ]]; then
      source "$ZSH_MODULE_DIR/$module_name.zsh"
      ZSH_MODULES+="$module_name"
    fi
  else
    zsh_module_bundle_remaining
  fi
}

function zsh_module_bundle_remaining {
  for module_file in $(find "$ZSH_MODULE_DIR" -type f -name '*.zsh'); do
    zsh_module_bundle "$(file_basename $module_file)"
  done
}

# update plugins
function zsh_plugins_update {
  for plugin_dir in $(find "$ZSH_PLUGIN_DIR" -type d -mindepth 1 -maxdepth 1); do
    echo "${fg_bold[blue]}* update plugin $plugin_dir$reset_color";
    cd $plugin_dir;
    local changed_files="$(git diff --name-only ..origin)"
    git pull
    if [ -n "$changed_files" ]; then
      echo "Updated:"
      echo "$changed_files" | sed -e 's/^/  /'
    fi
    echo " "
    cd - 1> /dev/null
  done
}

# update completions
function zsh_completions_update {
  for completion_file in $(find $ZSH_COMPLETION_DIR -name '_*' ); do
    cd $ZSH_COMPLETION_DIR;
    echo "${fg_bold[blue]}* update completion $completion_file$reset_color";
    local completion_file_url=$(cat "$(dirname $completion_file)/.$(file_basename $completion_file)")
    if [ $(curl -s -L -w %{http_code} -O -z $completion_file $completion_file_url) = '200' ]; then
      echo "From $completion_file_url"
      echo "Updated."
    else
      echo "File is up to date"
    fi
    echo " "
    cd - 1> /dev/null
  done
}

function zsh_plugin_load {
  local plugin_name=$1
  local plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
  local zsh_file=$2

  # try default files
  if [ -z "$zsh_file" ]; then
    if [ -e "$plugin_dir/$plugin_name.zsh" ]; then
      zsh_file="$plugin_name.zsh";
    elif [ -e "$plugin_dir/$plugin_name.plugin.zsh" ]; then
      zsh_file="$plugin_name.plugin.zsh";
    fi
  fi

  if [ ! -e "$plugin_dir/$zsh_file" ]; then
    echo "* $repo_name: zsh plugin file not found $plugin_dir/$zsh_file" 1>&2
    return;
  fi
  source "$plugin_dir/$zsh_file"
}

function zsh_plugin_bundle {
  local repo_url=$1
  local zsh_file=$2

  local plugin_name=$(file_basename "$repo_url")
  local plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"

  if [ ! -e "$plugin_dir" ]; then
    echo "${fg_bold[blue]}* install plugin $plugin_name$reset_color";
    git clone "$repo_url" "$plugin_dir"
    echo
  fi

  zsh_plugin_load $plugin_name $zsh_file
}


function zsh_completion_bundle {
  local file_url=$1
  local file_basename=$(file_basename "$file_url")
  local meta_file_basename=".$file_basename"

  if [ ! -e "$ZSH_COMPLETION_DIR/$file_basename" ]; then
    echo "${fg_bold[blue]}* install completion $file_basename$reset_color";
    echo "Downloading to $ZSH_COMPLETION_DIR/$file_basename"
    echo " "
    mkdir -p $ZSH_COMPLETION_DIR
    cd $ZSH_COMPLETION_DIR
    curl -s -L -O $file_url
    echo $file_url > $meta_file_basename # store url into meta file for allow updating
    cd - 1> /dev/null
  fi
}

# #### lazy load functions
# function zsh_functions_load {
#   autoload -U $(cd "$ZSH_FUNCTION_DIR" && 'ls')
# }


#### lazy load functions
function zsh_functions_load {
  for function_file in $(find "$ZSH_FUNCTION_DIR" -type f -name '*.zsh'); do
    local function_name="$(file_basename "$function_file")"
    alias $function_name='lazy_function_load '$function_file''
  done
}

function lazy_function_load {
  local function_file="$1"
  local function_name="$(file_basename "$function_file")"
  source "$function_file"
  if type -a $function_name | grep -q "$function_file"; then
    unalias $function_name
    $function_name \$@
  else
    echo "function '$function_name' can not be found within '$function_file'" 1>&2 
  fi
}
