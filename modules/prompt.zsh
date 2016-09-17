# Promt ########################################################################

# http://www.utf8icons.com/
# http://apps.timwhitlock.info/emoji/tables/unicode

autoload +X -U colors && colors

################
### PROMPT SETUP
################

setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt INTERACTIVE_COMMENTS # Allowes to use #-sign as comment within commandline

_prompt_cli_id=0
function _prompt_cli_id {
  _prompt_cli_id=$(expr $_prompt_cli_id + 1)
}
# run before prompt
precmd_functions=($precmd_functions _prompt_cli_id)

_prompt_exec_id=0
function _prompt_exec_id {
  _prompt_exec_id=$(expr $_prompt_exec_id + 1)
}
# run before execute command
preexec_functions=($preexec_functions _prompt_exec_id)

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
_prompt_exit_code_exec_id=0
function _prompt_exit_code {
  local exit_code=$?
  if [ $exit_code != 0 ] && [ $_prompt_exec_id != $_prompt_exit_code_exec_id ]; then
    echo "${fg_bold[red]}✖ $exit_code$reset_color"
  fi
  _prompt_exit_code_exec_id=$_prompt_exec_id
}
# run before prompt
precmd_functions=(_prompt_exit_code $precmd_functions)


###### REZIZE TERMINAL WINDOW ##################################################
# Ensure that the prompt is redrawn when the terminal size changes.
function TRAPWINCH {
  if [ $_prompt_cli_id -gt 1 ]; then # prevent segmentation fault
    zle && { zle reset-prompt; zle -R }
  fi
}

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
