autoload +X -U colors && colors

###### Prompt Configuration ####################################################

function _prompt_info {

  # --- prompt indicator
  local prompt_info="${fg_bold[grey]}#${reset_color} "

  # --- username
  if [ $EUID = 0 ]; then # highlight root user
    prompt_info+="${fg_bold[red]}${USER}${reset_color}" 
  else
    prompt_info+="${fg[cyan]}${USER}${reset_color}"
  fi
  
  # --- hostname
  prompt_info+="${fg_bold[grey]}@${reset_color}${fg[blue]}${HOST:-HOSTNAME}${reset_color}"

  # --- directory
  # shorten $PWD: replace $HOME wit '~' and parent folders with first character only
  local current_dir=${${PWD/#$HOME/'~'}//(#m)[^\/]##\//${MATCH[1]}/} 
  prompt_info+=" ${fg_bold[grey]}in${reset_color} ${fg[yellow]}$current_dir${reset_color}"

  # --- git branch
  local current_branch_status_line="$(git status --short --branch --porcelain 2>/dev/null | head -1)"
  if [ -n "$current_branch_status_line" ]; then
    if [[ "$current_branch_status_line" == *"(no branch)"* ]]; then
        prompt_info+=" ${fg_bold[grey]}at${reset_color} ${fg[green]}detached HEAD${reset_color}"
    else
        local branch_name="${${current_branch_status_line#*' '}%%'...'*}"
        prompt_info+=" ${fg_bold[grey]}on${reset_color} ${fg[green]}${branch_name}$current_branch${reset_color}"
    fi

    if [ -n "$(git status --short --porcelain 2>/dev/null)" ]; then
      prompt_info+="${fg_bold[magenta]}*${reset_color}"
    fi
    
    prompt_info+=' '
    if [[ "$current_branch_status_line" == *"ahead"* ]]; then
      prompt_info+="${fg_bold[magenta]}⇡${reset_color}"
    fi
    
    if [[ "$current_branch_status_line" == *"behind"* ]]; then
      prompt_info+="${fg_bold[magenta]}⇣${reset_color}"
    fi
  fi

  echo -e "$prompt_info"
}

precmd_functions=($precmd_functions _prompt_info)
PS1='‣ '
PS2='• '
# right prompt
# RPROMPT='[%D{%H:%M:%S}]' # date


###### Handle Exit Codes #######################################################

_prompt_exec_id=0
function _prompt_exec_id_increment { ((_prompt_exec_id++)) }
preexec_functions=(_prompt_exec_id_increment $preexec_functions)

_prompt_cmd_id=0
function _prompt_handle_exit_code {
  local exit_code=$status
  if [ $exit_code != 0 ] && [ $_prompt_exec_id != $_prompt_cmd_id ]; then
    echo "${fg_bold[red]}✖ ${exit_code}${reset_color}"
  fi
  _prompt_cmd_id=$_prompt_exec_id
}
precmd_functions=(_prompt_handle_exit_code $precmd_functions)

# print indicator when commandline is interupted
function _promp_handle_interupt {
  local FULLBUFFER="${PREBUFFER}${BUFFER}"
  if [ -n "$FULLBUFFER" ]; then
    local exit_code=130
    echo -en "\n${fg_bold[grey]}◆ ${exit_code}${reset_color}"
  fi
}
trap '_promp_handle_interupt; return INT' INT


###### Misc ####################################################################

### Ensure that the prompt is redrawn when the terminal size changes.
function TRAPWINCH {
  zle && { zle reset-prompt; zle -R }
}

####  clear screen for mutiline prompt
function _clear_screen_widget { 
  tput clear
  local precmd
  for precmd in $precmd_functions; do
      $precmd
  done
  zle reset-prompt
}
zle -N _clear_screen_widget
bindkey "^L" _clear_screen_widget

