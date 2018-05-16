autoload +X -U colors && colors

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

alias history_edit='(){ ${1:-$EDITOR} $HISTFILE && fc -R }'

# "predefined history"
# just write important commands you always need to ~/.important_commands
# if [[ -r ~/.important_commands ]] ; then
#     fc -R ~/.important_commands
# fi

if type fzf >/dev/null; then
  function _history_widget {

    local BUFFER_ORIGIN=${BUFFER}
    local CURSOR_ORIGIN=${CURSOR}

    BUFFER=''
    zle -Rc
    echo -n "${fg_bold[magenta]}…${reset_color}"

    local query=${BUFFER_ORIGIN} # whole command

    local cmd=$(history -n 0 | \
        fzf --height 10 --reverse --tac --exact --no-sort --query=${query} --select-1)

    if [ -n ${cmd} ]; then
      BUFFER="${cmd}"
      CURSOR=${#BUFFER}
    else
      BUFFER=${BUFFER_ORIGIN}
      CURSOR=${CURSOR_ORIGIN}
    fi

    zle redisplay
  }
  zle -N _history_widget
  bindkey '^R' _history_widget

  function _history_argument_widget {

    BUFFER_ORIGIN=${BUFFER}
    CURSOR_ORIGIN=${CURSOR}
    LBUFFER_ORIGIN=${LBUFFER}
    RBUFFER_ORIGIN=${RBUFFER}

    BUFFER=''
    zle -Rc
    echo -n "${LBUFFER_ORIGIN%${query}}${fg_bold[magenta]}…${reset_color}${RBUFFER_ORIGIN}"

    local query=${${${(z)${:-_ ${LBUFFER_ORIGIN}}}[-1]}#_} # left cursor side argument
    if [[ ${LBUFFER_ORIGIN} == *' ' ]] && [[ ! ${query} == *' ' ]]; then
      query=''
    fi

    local argument=$(history -n 0 | (while read line; do echo ${(j:\n:)${(z)line}}; done) | nl | sort -r | sort -k2 -u | sort -k1 -n | cut -f2- | \
        fzf --height 10 --reverse --tac --exact --no-sort --query=${query} --select-1)

    if [ -n ${argumen} ]; then
      BUFFER="${LBUFFER_ORIGIN%$query}${argument}${RBUFFER_ORIGIN}"
      CURSOR=${#${:-"${LBUFFER_ORIGIN%${query}}${argument}"}}
    else
      BUFFER=${BUFFER_ORIGIN}
      CURSOR=${CURSOR_ORIGIN}
    fi

    zle redisplay
  }
  zle -N _history_argument_widget
  bindkey '^@' _history_argument_widget
fi
