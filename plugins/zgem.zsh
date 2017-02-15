autoload +X -U colors && colors

########################## zgem #########################

declare -rx ZGEM_DIR=${ZGEM_DIR:-"$HOME/.zgem"}

ZGEM_VERBOSE="${ZGEM_VERBOSE:-false}"

function zgem {
  local cmd="$1"
  shift

  case "$cmd" in
    'bundle')
      _zgem::bundle $@
      ;;
    'update')
      _zgem::update $@
      _zgem::reload
      ;;
    'clean')
      _zgem::clean
      ;;
    *)
      _zgem::log error "Unknown command '$cmd'"
      _zgem::log error "Usage: $0 {add|update}"
      return 1
      ;;
  esac
}

function _zgem::reload {
  exec "$SHELL" -l
}

function _zgem::clean {
  _zgem::log info "Press ENTER to remove '$ZGEM_DIR/'..." && read
  rm -rf "$ZGEM_DIR"
}

function _zgem::bundle {
  local location="$1"
  shift

  ################ parse parameters ################

  local protocol='file'
  local gem_file="$(_zgem::basename "$location")"
  local gem_type='plugin'
  local lazy_load=''
  for param in "$@"; do
    local param_key="${param[(ws|:|)1]}"
    local param_value="${param[(ws|:|)2]}"

    case "$param_key" in
      'from')
        protocol="$param_value"
        ;;
      'use')
        gem_file="$param_value"
        ;;
      'as')
        gem_type="$param_value"
        ;;
      'lazy')
        lazy_load="$param_value"
        ;;
      *)
        _zgem::log error "Unknown parameter '$param_key'"
        _zgem::log error "Parameter: {from|use|as}"
        return 1
        ;;
    esac
  done

  ################ determine gem dir and file ################
  
  local gem_name
  if type "_zgem::name::$protocol" > /dev/null; then
    gem_name="$(_zgem::name::$protocol "$location")"
  else
    _zgem::log error "command not found '_zgem::name::$protocol'" && return 1
  fi
  
  local gem_dir="${ZGEM_DIR}/${gem_name}"
  if [ "$protocol" = 'file' ]; then
    gem_dir="$(_zgem::dirname "$location")"
  fi

  ################ download gem ################
  
  if [ ! -e "$gem_dir" ] && [ "$protocol" != 'file' ]; then
    if ! type "_zgem::download::$protocol" > /dev/null; then
      _zgem::log error "command not found '_zgem::download::$protocol'" && return 1
    fi
    
    mkdir -p "$gem_dir"
    echo "$protocol" > "$gem_dir/.gem"
    _zgem::log info "${fg_bold[green]}download${reset_color} ${gem_name}${fg_bold[yellow]}\n       into${reset_color} '$gem_dir'\n       ${fg_bold[yellow]}from${reset_color} '$location'"
    _zgem::download::$protocol "$location" "$gem_dir"
  fi

  ################ load gem ################

  case "$gem_type" in
    'plugin')
      _zgem::add::plugin "$gem_dir/$gem_file" "$lazy_load"
      ;;
    'completion')
      _zgem::add::completion "$gem_dir/$gem_file"
      ;;
    *)
      _zgem::log error  "Unknown gem type '$protocol'"
      _zgem::log error  "Gem Type: {plugin|completion}"
      return 1 ;;
  esac
}

function _zgem::add::completion {
  local path="$1"
  _zgem::log debug "${fg_bold[green]}completion${reset_color}     '$path'"
  fpath=($fpath "$(_zgem::basename '$path' )")
}

function _zgem::add::plugin {
  local gem_file="$1"
  local lazy_functions="$2"

  if [ -z "$lazy_functions" ]; then
    _zgem::log debug "${fg_bold[green]}plugin${reset_color}         '$gem_file'"
    source "$gem_file"
  else
    _zgem::log debug "${fg_bold[green]}plugin${reset_color}         '$gem_file' ${fg_bold[blue]}lazy${reset_color} '${lazy_functions}'"
    for lazy_function in ${(ps:,:)${lazy_functions}}; do
      lazy_function=$(echo $lazy_function | tr -d ' ') # re move whitespaces
      eval "$lazy_function() { source '$gem_file' && $lazy_function; }"
    done
  fi
}

function _zgem::update {
  for gem_dir in $(find "$ZGEM_DIR" -type d -mindepth 1 -maxdepth 1); do
    local protocol="$(cat "$gem_dir/.gem")"
    if type "_zgem::update::$protocol" > /dev/null; then
      local gem_name="$(_zgem::basename "$gem_dir")"
      _zgem::log info "${fg_bold[green]}update${reset_color} ${gem_name}\n       ${fg_bold[yellow]}in${reset_color} '$gem_dir'";
      _zgem::update::$protocol $gem_dir 
    else
      _zgem::log error "command not found '_zgem::update::$protocol' gem directory: '${gem_dir}'"
    fi
  done
}

#### faster than basename command
function _zgem::basename {
  local name="$1"
  local sufix="$2"
  name="${name##*/}"
  name="${name%$sufix}"
  echo "$name"
}

#### faster than dirname command
function _zgem::dirname {
  local name="$1"
  name="${name%/*}"
  echo "$name"
}

function _zgem::log {
  local level="$1"
  shift

  case "$level" in
    'error')
      echo "${fg_bold[red]}[zgem]${reset_color}" $@ >&2
      ;;
    'info')
      echo "${fg_bold[blue]}[zgem]${reset_color}" $@
      ;;
    'debug')
      $ZGEM_VERBOSE && echo "${fg_bold[yellow]}[zgem]${reset_color}" $@
      ;;
    *)
      _zgem::log error "Unknown log level '$protocol'"
      _zgem::log error "Log Level: {error|info|debug}"
      ;;
  esac
}
############################# file ############################

function _zgem::name::file {
  local path="$1"
  _zgem::basename "$path"
}

############################# http ############################

function _zgem::name::http {
  local http_url="$1"
  _zgem::basename "$http_url"
}

function _zgem::download::http {
  local http_url="$1"
  local gem_dir="$2"
  (
    cd "$gem_dir"
    echo "$http_url" > ".http" # store url into meta file for allow updating
    echo "Downloading into '$gem_dir'"
    curl -L -O "$http_url"
  )
}

function _zgem::update::http {
  local gem_dir="$1"
  (
    cd "$gem_dir"
    local http_url=$(cat "$gem_dir/.http")
    local file="$(_zgem::basename "$http_url")"
    local file_new=".$file.download"
    curl -L -w %{http_code} -o "$file_new" -z "$file" $http_url | read -r response_code
    if [ $response_code = '200' ]; then 
      if ! diff "$file" "$file_new" >/dev/null; then
        mv "$file" ".$file.old"
        mv "$file_new" "$file"
        echo "From $http_url"
        echo "Updated."
      else
        echo "Current file is up to date"
      fi
    elif [ $response_code = '304' ]; then
      echo "Current file is up to date"
    else 
      _zgem::log error "http update error response code: $response_code from '$http_url'"
    fi
  )
}

############################# git #############################

function _zgem::name::git {
  local repo_url="$1"
  _zgem::basename "$repo_url" '.git'
}

function _zgem::download::git {
  local repo_url="$1"
  local gem_dir="$2"
  (
    cd "$gem_dir"
    local clone_dir="git_repo"
    git clone --depth 1 "$repo_url" "$clone_dir" && mv "$clone_dir/"*(DN) . && rmdir "$clone_dir"
  )
}

function _zgem::update::git {
  local gem_dir="$1"
  (
    cd "$gem_dir"
    git pull # --depth 1
    local last_commit_hash=$(git reflog | grep -A1 'clone\|pull' | head -2 | tail -1 | cut -d" " -f1)  
    git diff --name-status $last_commit_hash HEAD
  )
}
