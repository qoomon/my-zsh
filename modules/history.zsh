# History ######################################################################
HISTFILE=${ZDOTDIR:-$HOME}/.zhistory        # enable history saving on shell exit
HISTSIZE=10000                  # lines of history to maintain memory
SAVEHIST=$HISTSIZE              # lines of history to maintain in history file.
# fc -R -I                        # reads the history file $HISTSIZE
setopt EXTENDED_HISTORY         # save timestamp and runtime information
setopt APPEND_HISTORY           # append rather than overwrite history file.
setopt INC_APPEND_HISTORY       # append to history immediately.
setopt SHARE_HISTORY            # Use the same history file for all sessions

setopt HIST_IGNORE_ALL_DUPS     # ignore all duplication in command history list
# setopt HIST_IGNORE_DUPS        # ignore consecutive duplication in command history list
# setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE        # Do not include lines beginning with a space in the history file
setopt HIST_VERIFY              # let the user edit the command line after history expansion
setopt NO_HIST_BEEP

alias history_edit='$EDITOR $HISTFILE && fc -R'

# "predefined history"
# just write important commands you always need to ~/.important_commands
# if [[ -r ~/.important_commands ]] ; then
#     fc -R ~/.important_commands
# fi

if type fzf >/dev/null; then
  function _history_widget {
    local query=${LBUFFER}}
    local cmd=$(history -n 0 | \
        fzf --height 10 --reverse --tac --exact --no-sort --query=${query})
    if [ -n "$cmd" ]; then
      BUFFER="$cmd"
      CURSOR=${#BUFFER}
    fi
    zle redisplay
  }
  zle -N _history_widget
  bindkey '^R' _history_widget
fi

if type fzf >/dev/null; then
  function _history_argument_widget {

    local last_argument=${${${(z)${:-_ ${LBUFFER}}}[-1]}#_}
    if [[ ${LBUFFER} == *' ' ]] && [[ ! ${last_argument} == *' ' ]]; then
      last_argument=''
    fi
    
    local query=${last_argument}
    
    local argument=$(history -n 0 | (while read line; do echo ${(j:\n:)${(z)line}}; done) | nl | sort -k2 -u | sort -k1 -n | cut -f2- | \
        fzf --tac --no-sort --reverse --height=20 --query=${query})
    if [ -n "$argument" ]; then
      BUFFER="${LBUFFER%$last_argument}$argument"
      CURSOR=${#BUFFER}
    fi
    zle redisplay
  }
  zle -N _history_argument_widget
  bindkey '^H' _history_argument_widget
fi
