autoload -Uz colors && colors

# History ######################################################################
HISTSIZE=10000                             # lines of history to maintain memory
HISTFILE=${ZDOTDIR:-$HOME}/${HISTFILE##*/} # history file location, Disaable history by unset HISTFILE
SAVEHIST=10000                             # lines of history to maintain in history file.

setopt EXTENDED_HISTORY         # save timestamp and runtime information
setopt SHARE_HISTORY            # Use the same history file for all sessions
setopt APPEND_HISTORY           # append rather than overwrite history file.
setopt INC_APPEND_HISTORY       # append to history immediately.

function history-off { HIST=off }
function history-on  { unset HIST }
function history-edit { ${1:-$EDITOR} $HISTFILE && fc -R }

function zshaddhistory {   
    # command_line always ends in a newline
    local command_line=$1
    # ignore all commands if HIST is off
    if [[ $HIST && $HIST != on ]]; then return 1; fi
    # ignore commands with more than 512 characters
    if [ ${#command_line} -gt 512 ]; then return 1; fi
    # ignore commands with more than 24 lines
    if [ ${#${(f)command_line[@]}} -gt 24 ]; then return 1; fi
    # ignore cd commands
    if [[ $command_line =~ ^(cd|cd -|cd \.\.)[[:space:]]*$ ]]; then return 1; fi
} 

setopt HIST_IGNORE_SPACE        # Do not include lines beginning with a space in the history file
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplication in command history list
# setopt HIST_IGNORE_DUPS        # ignore consecutive duplication in command history list
# setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt HIST_FIND_NO_DUPS

# setopt SINGLE_LINE_ZLE         # single line command history
setopt HIST_VERIFY              # let the user edit the command line after history expansion
setopt NO_HIST_BEEP
setopt HIST_NO_STORE            # Remove the history (fc -l) command from the history list when invoked.
