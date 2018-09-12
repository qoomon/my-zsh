# print one line annotation with comment 
function annotation {
  local comment=$1
  echo
  echo "${bg[grey]}${fg_bold[default]}\e[2K  ⇛ ${comment}${reset_color}"
  echo
}

# make it possible to undo abort command line
function zle-line-init {
 if [[ -n $ZLE_LINE_ABORTED ]]; then
   local buffer_save="$BUFFER"
   local cursor_save="$CURSOR"
   BUFFER="$ZLE_LINE_ABORTED" 
   CURSOR="${#BUFFER}" 
   zle split-undo
   BUFFER="$buffer_save" CURSOR="$cursor_save" 
 fi
}
zle -N zle-line-init