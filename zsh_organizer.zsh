##############################################################################
### Organizer
### - zsh Manager for Plugins, Completions and Modules
##############################################################################
autoload +X -U colors && colors

export ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR:-"$HOME"}
declare -r ZSH_CONFIG_DIR

export ZSH_MODULE_DIR="$ZSH_CONFIG_DIR/modules"
declare -r ZSH_MODULE_DIR

export ZSH_FUNCTION_DIR="$ZSH_CONFIG_DIR/functions"
declare -r ZSH_FUNCTION_DIR

export ZSH_LIB_DIR="$ZSH_CONFIG_DIR/lib"
declare -r ZSH_LIB_DIR

export ZSH_PLUGIN_DIR="$ZSH_LIB_DIR/plugins"
declare -r ZSH_PLUGIN_DIR

export ZSH_COMPLETION_DIR="$ZSH_LIB_DIR/completion"
declare -r ZSH_COMPLETION_DIR

export ZSH_FILE_DIR="$ZSH_CONFIG_DIR/files"
declare -r ZSH_FILE_DIR

export APP_CONFIG_DIR="$ZSH_CONFIG_DIR/configs"
declare -r APP_CONFIG_DIR


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

  zsh_update_plugins

  zsh_update_completions

  zsh_reload
}

##################
### MODULES
##################

function zsh_bundle_module {
  local module_name=$1
  source "$ZSH_MODULE_DIR/$module_name.zsh"
}


##################
### PLUGINS
##################

function zsh_bundle_plugin {
  local repo_url=$1
  local zsh_file=$2

  local plugin_name=$(_basename "$repo_url" '.git')
  local plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"

  if [ ! -e "$plugin_dir" ]; then
    echo "${fg_bold[blue]}* install plugin $plugin_name$reset_color";
    git clone --depth 1 "$repo_url" "$plugin_dir"
    echo
  fi

  zsh_load_plugin $plugin_name $zsh_file
}

function zsh_load_plugin {
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


# update plugins
function zsh_update_plugins {
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


##################
### COMPLETIONS
##################

fpath=($fpath "$ZSH_COMPLETION_DIR")

function zsh_bundle_completion {
  local file_url=$1
  local file_name=$(_basename "$file_url")
  local meta_file_name=".$file_name"

  if [ ! -e "$ZSH_COMPLETION_DIR/$file_name" ]; then
    echo "${fg_bold[blue]}* install completion $file_name$reset_color";
    echo "Downloading to $ZSH_COMPLETION_DIR/$file_name"
    echo " "
    mkdir -p $ZSH_COMPLETION_DIR
    cd $ZSH_COMPLETION_DIR
    curl -s -L -O $file_url
    echo $file_url > $meta_file_name # store url into meta file for allow updating
    cd - 1> /dev/null
  fi
}

# update completions
function zsh_update_completions {
  for completion_file in $(find "$ZSH_COMPLETION_DIR" -name '_*' ); do
    cd $ZSH_COMPLETION_DIR;
    echo "${fg_bold[blue]}* update completion $completion_file$reset_color";
    local completion_file_url=$(cat "$(_dirname $completion_file)/.$(_basename $completion_file)")
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


##################
### APP CONFIGS  
##################

function app_config_apply {
  local appName=$1
  zsh $APP_CONFIG_DIR/${appName}.zsh
  echo "$appName config applied"
}

function app_config_apply_all {
  for completion_file in $(find "$APP_CONFIG_DIR" -name '*.zsh' ); do
    app_config_apply $(_basename $completion_file '.zsh')
  done
}

##################
### Helper  
##################

#### faster than basename command
function _basename { 
  local name=$1
  local sufix=$2
  name=${name##*/}; 
  name=${name%$sufix}; 
  echo $name
}

#### faster than dirname command
function _dirname { 
  local name=$1
  name=${name%/*}; 
  echo $name
}
