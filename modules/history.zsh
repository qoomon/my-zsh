# History ######################################################################
HISTFILE=${ZDOTDIR:-$HOME}/.zhistory        # enable history saving on shell exit
HISTSIZE=10000                  # lines of history to maintain memory
SAVEHIST=$HISTSIZE              # lines of history to maintain in history file.
setopt EXTENDED_HISTORY         # save timestamp and runtime information
setopt APPEND_HISTORY           # append rather than overwrite history file.
setopt INC_APPEND_HISTORY       # append to history immediately.

setopt HIST_EXPIRE_DUPS_FIRST   # allow dups, but expire old ones when I hit HISTSIZE
#setopt HIST_IGNORE_DUPS        # ignore consecutive duplication in command history list
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplication in command history list
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY              # let the user edit the command line after history expansion
setopt SHARE_HISTORY            # Use the same history file for all sessions
setopt NO_HIST_BEEP
