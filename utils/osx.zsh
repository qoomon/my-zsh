
# open man page in mac os Preview App
function man-preview {
  man -t $1 | open -f -a Preview
  # MANWIDTH=120 MANPAGER='col -bx' man ls | groff -P-pa4 -Tps -mandoc -c | open -f -a Preview.app
}

function notify {
  local title=${1/\"/\\\"}
  local message=${2/\"/\\\"}
  local subtitle=${3/\"/\\\"}
  local sound=${4/\"/\\\"}

  local script="display notification \"$message\" with title \"$title\" subtitle \"$subtitle\""
  if [ -n "$sound" ]; then
    script="$script sound name \"$sound\""
  fi

  osascript -e "$script"
}
