# Open new iTerm tabs from the command line
#
# Author: Bengt Brodersen
#
# Usage:
#     tab                   Opens the current directory in a new pane
#     tab [PATH]            Open PATH in a new pane
#     tab [CMD]             Open a new tab and execute CMD
#     tab [PATH] [CMD] ...  You can prolly guess
function pane {
    local split="V"
    local cmd=$(echo "$@")
    if [ "$1" = "-V" ]; then
      # split vertically
      split="V"
      cmd=$(echo "${${@}[@]:1}")
    fi
    if [ "$1" = "-H" ]; then
      # split horizontal
      split="H"
      cmd=$(echo "${${@}[@]:1}")
    fi

    cmd=$(echo "$cmd" | sed 's/\\\\/\\\\\\\\/g' | sed 's/"/\\\"/g')

    case "$TERM_PROGRAM" in

      'iTerm.app')
        if [ "$split" = "V" ]; then
          # split vertically
          osascript -e "tell application \"System Events\" to keystroke \"d\" using {command down}"
        fi
        if [ "$split" = "H" ]; then
          # split horizontal
          osascript -e "tell application \"System Events\" to keystroke \"d\" using {command down, shift down}"
        fi

        if [ -n "$cmd" ]; then
          # execute command
          osascript -e "tell application \"System Events\" to keystroke \"$cmd\n\""
        fi
        ;;
      *)
        echo "Unsuported terminal: $TERM_PROGRAM" >&2
        return 1
        ;;
    esac
}

function panex {
    local col_count=4
    if [ -z "$col_count" ]; then
      col_count=1
    fi

    case "$TERM_PROGRAM" in
      'iTerm.app')
        # new window
        osascript -e "tell application \"System Events\" to keystroke \"n\" using {command down}"
        # maximize window
        osascript -e "tell application \"System Events\" to keystroke \"=\" using {command down, option down}"
        ;;
      *)
        echo "Unsuported terminal: $TERM_PROGRAM" >&2
        return 1
        ;;
    esac


    local command_count=$#
    local command_id=0
    for cmd in "$@"; do
      command_id=$(($command_id + 1))
      if [ $command_id -eq 1 ]; then
        # execute first command in current window
        if [ -n "$cmd" ]; then
          osascript -e "tell application \"System Events\" to keystroke \"$cmd\n\""
        fi
      else
        if [ $command_id -le $col_count ]; then
          pane -V "$cmd"
        else
          pane -H "$cmd"
        fi
        if [ $command_id -ge $col_count ] && [ $command_id -lt $command_count ]; then
          # jump first column
          # (ASCII character 29) = arrow right
          osascript -e "tell application \"System Events\" to keystroke (ASCII character 29) using {option down, command down}"
        fi
      fi
    done
}
