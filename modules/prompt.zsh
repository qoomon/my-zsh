# Promt ########################################################################

# http://www.utf8icons.com/
# http://apps.timwhitlock.info/emoji/tables/unicode

autoload +X -U colors && colors

################
### PROMPT SETUP
################

setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt INTERACTIVE_COMMENTS # Allowes to use #-sign as comment within commandline

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

###### Command Line ############################################################

function _prompt_info {

  local current_user="$(whoami)"
  local current_host="$(hostname -s)"
  local current_dir="$(pwd | sed -e "s|^$HOME|~|" -e 's|\([^~/.]\)[^/]*/|\1…/|g')"
  local current_branch="$(git branch 2> /dev/null | sed -n '/\* /s///p' | sed 's/^( *//;s/ *)$//;')"

  # precmd start
  local precmd="${fg_bold[grey]}#$reset_color "

  # current_user & current_host
  if [ "$current_user" = "root" ]; then precmd+="${fg_bold[red]}"; else precmd+="${fg[cyan]}"; fi
  precmd+="$current_user$reset_color${fg_bold[grey]}@$reset_color${fg[blue]}$current_host$reset_color"

  # current_dir
  precmd+=" ${fg_bold[grey]}in$reset_color ${fg[yellow]}$current_dir$reset_color"

  # current_branch
  if [ -n "$current_branch" ]; then
    if [[ "$current_branch" != "detached "* ]]; then
      precmd+=" ${fg_bold[grey]}on$reset_color"
    fi
    precmd+=" ${fg[green]}$current_branch$reset_color"
  fi

  echo "$precmd"

}
precmd_functions=($precmd_functions _prompt_info)
PS1='❯ '
PS2='▪ '

## promptsubst made some problems while completion e.g. remove previous comandline
#setopt promptsubst # substitude variables within prompt string
#PS1='$(_prompt_info)
#❯ '
#PS2='▪ '


# right prompt
# RPROMPT='[%D{%H:%M:%S}]' # date

###### EXIT CODE ###############################################################
# print exit code on error

_PROMPT_EXEC_ID=0
_PROMPT_CMD_EXEC_ID=0

# run before execute command
function _prompt_exit_code_preexec {
  _PROMPT_EXEC_ID=$(expr $_PROMPT_EXEC_ID + 1)
}
preexec_functions=($preexec_functions _prompt_exit_code_preexec)

# run before command line
function _prompt_exit_code_precmd {
  local exit_code=$?
  if [ $exit_code -ne 0 ] && [ $_PROMPT_EXEC_ID -ne $_PROMPT_CMD_EXEC_ID ]; then
    echo "${fg_bold[red]}✖ $exit_code$reset_color"
  fi
  _PROMPT_CMD_EXEC_ID=$_PROMPT_EXEC_ID
}
precmd_functions=($precmd_functions _prompt_exit_code_precmd)

################
### PROMPT UTILS
################

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

function _print_divider { # print online of divider icons
  local dividerIcon="▪"   # ≡ ▪ ◊ ◄►
  local dividerSpaces="$(echo $dividerIcon | sed 's|.| |g')"

  #zle clear-screen
  printf '\e[0K\r\e[0K\r%*s' "$( expr ${COLUMNS:-$(tput cols)} - 2 )" '' | sed "s|$dividerSpaces|$dividerIcon|g"
  zle reset-prompt
}
zle -N _print_divider
bindkey "^N" _print_divider

function _clear_screen { # clear screen without coping last line
  printf '\e[0K\r\e[0K\r'
  zle clear-screen
}
zle -N _clear_screen
bindkey "^L" _clear_screen
