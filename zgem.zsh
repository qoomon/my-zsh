
autoload +X -U colors && colors

declare -rx  ZGEM_DIR=${ZGEM_DIR:-"$HOME/.zgem"}

echo "${fg_bold[yellow]}[zgem]${fg_bold[blue]} gem directory ${reset_color} '$ZGEM_DIR'"

function zgem {
  local cmd=$1
  shift
  case "$cmd" in
    'add')
      zgem::add $@
      ;;
    'update')
      zgem::update $@
      zgem::zsh_reload
      ;;
    *)
      echo "Unknown command '$cmd'"
      echo "Usage: $0 {add|update} " >&2
      return 1 ;;
  esac
}

function zgem::add {
  local location=$1
  shift

  local protocol="file"
  local file=""
  local gem_type="source"

  for param in "$@"; do
    local param_key="${param[(ws|:|)1]}"
    local param_value="${param[(ws|:|)2]}"

    case "$param_key" in
      'from')
        protocol="$param_value"
        ;;
      'use')
        file="$param_value"
        ;;
      'as')
        gem_type="$param_value"
        ;;
      *)
        echo "Unknown parameter '$param_key'"
        echo "Parameter: {from|use|as} " >&2
        return 1 ;;
    esac
  done

  local gem_dir
  case "$protocol" in
    'file')
      file="$(zgem::basename "$location")"
      gem_dir="$(zgem::dirname "$location")"
      ;;
    'http')
      file=$(zgem::basename "$location")
      local gem_name="$file"
      gem_dir="${ZGEM_DIR}/${gem_name}.http"
      zgem::install::http "$location" "$gem_dir"
      ;;
    'git')
      local gem_name="$(zgem::basename "$location")"
      gem_dir="$ZGEM_DIR/${gem_name}.git"
      zgem::install::git "$location" "$gem_dir"
      ;;
    *)
      echo "Unknown protocol '$protocol'"
      echo "Protocol: {file|http|git} " >&2
      return 1 ;;
  esac

  zgem::load "$gem_dir" "$file" "$gem_type"

}

function zgem::load {
  local gem_dir=$1
  local file=$2
  local gem_type=$3

  case "$gem_type" in
    'completion')
      echo "${fg_bold[yellow]}[zgem]${fg_bold[green]} completion ${reset_color}    '$gem_dir/$file'"
      fpath=($fpath "$gem_dir")
      ;;
    *)
      echo "${fg_bold[yellow]}[zgem]${fg_bold[green]} source     ${reset_color}    '$gem_dir/$file'"
      source "$gem_dir/$file"
      ;;
  esac
}

function zgem::update {
  for gem_dir in $(find "$ZGEM_DIR" -type d -mindepth 1 -maxdepth 1); do
    echo "${fg_bold[blue]}* update gem${reset_color} $gem_dir";

    local gem_name="$(zgem::basename "$gem_dir")"
    local protocol="${gem_name##*.}"
    case "$protocol" in
      'http')
        zgem::update::http $gem_dir
        ;;
      'git')
        zgem::update::git $gem_dir
        ;;
      *)
        echo "Unknown protocol '$protocol'"
        echo "Protocol: {http|git} " >&2
        return 1 ;;
    esac
  done
}

function zgem::zsh_reload {
  exec "$SHELL" -l
}


############################# http ############################

function zgem::install::http {
  local http_url="$1"
  local gem_dir="$2"

  if [ ! -e "$gem_dir" ]; then
    echo "${fg_bold[blue]}* install gem $gem_dir ${reset_color}"
    mkdir -p "$gem_dir"
    echo "$http_url" > "$gem_dir/.http" # store url into meta file for allow updating
    echo "Downloading into '$gem_dir'"
    (cd "$gem_dir"; curl -L -O "$http_url")
  fi
}

function zgem::update::http {
  local gem_dir=$1

  local http_url=$(cat "$gem_dir/.http")
  local file="$(zgem::basename "$http_url")"

  cd $gem_dir;
  if [ $(curl -s -L -w %{http_code} -O -z "$file" "$http_url") = '200' ]; then
    echo "From $http_url"
    echo "Updated."
  else
    echo "File is up to date"
  fi
  echo " "
  cd - 1> /dev/null
}

############################# git #############################

function zgem::install::git {
  local repo_url=$1
  local gem_dir="$2"

  if [ ! -e "$gem_dir" ]; then
    echo "${fg_bold[blue]}* install gem $gem_dir ${reset_color}"
    mkdir -p "$gem_dir"
    git clone --depth 1 "$repo_url" "$gem_dir"
  fi
}

function zgem::update::git {
  local gem_dir=$1

  cd $gem_dir;
  local changed_files="$(git diff --name-only ..origin)"
  git pull
  if [ -n "$changed_files" ]; then
    echo "Updated:"
    echo "$changed_files" | sed -e 's/^/  /'
  fi
  echo " "
  cd - 1> /dev/null
}


##################
### COMPLETIONS
##################


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
function zgem::basename {
  local name=$1
  local sufix=$2
  name=${name##*/};
  name=${name%$sufix};
  echo $name
}

#### faster than dirname command
function zgem::dirname {
  local name=$1
  name=${name%/*};
  echo $name
}
