# Completions ##################################################################
# see http://zsh.sourceforge.net/Doc/Release/Completion-System.html
#Layout is :completion:FUNCTION:COMPLETER:COMMAND-OR-MAGIC-CONTEXT:ARGUMENT:TAG
autoload +X -U colors && colors

autoload +X -U compinit
compinit -C # Speed up compinit by not checking cache (-C).
if [ -z "$(find "${ZDOTDIR:-$HOME}/.zcompdump" -newermt '-1 day')" ]; then
  echo 'Initialize Completions'
  rm -rf "${ZDOTDIR:-$HOME}/.zcompdump"
  compinit
fi

autoload +X -U keeper

################
### COMPLETION SETUP
################

WORDCHARS=''
LISTMAX=0 # Only ask before displaying completions if doing so would scroll.
ZLE_SPACE_SUFFIX_CHARS=$'&|' # do not remove space after completion for '&' and '|'

## Options
# see http://www.cs.elte.hu/zsh-manual/zsh_16.html
setopt auto_list
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

# list of completers to use
# zstyle ':completion:*' completer  _complete _expand _list _match _prefix

## Use completion cache
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

zstyle ':completion:*' verbose yes # show descriptions for options for many commands
zstyle ':completion:*' extra-verbose yes

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'  # Case-Insensitive Completion
# zstyle ':completion:*' matcher-list 'r:|?=** m:{[:lower:][:upper:]}={[:upper:][:lower:]}'  # fuzzy & Case-Insensitive Completion

zstyle ':completion:*' accept-exact '*(N)' # forces prefix matching
zstyle ':completion:*' select-prompt '%Sat %p%s' # Add position hint to prompt when there are a lot of choices
zstyle ':completion:*' force-list always # always show comletion also if not ambiguous
zstyle ':completion:*' list-separator '--' # seperator between completion and description
zstyle ':completion:*' group-name '' # group matches by tag
zstyle ':completion:*:functions' ignored-patterns '_*' # Ignore private functions
zstyle ':completion:*:parameters' ignored-patterns '_*' # Ignore private parameters

zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description 'specify: %d'

zstyle ':completion:*:descriptions' format '%F{yellow}< %d >%f' # enable and format completion groups
zstyle ':completion:*:warnings' format '%F{red}no matches found%f' # enable and format no match
zstyle ':completion:*:messages' format '%F{purple}%d%f'
#zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' ignore-parents parent pwd # cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*' list-dirs-first yes # list folders first on completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # colorize file system completion

# ## Menu behaviour
# zstyle ':completion:*' menu select # interactive # always show completions
# zstyle ':completion:*:default' menu yes=0 select=0
zstyle ':completion:*:default' menu select
zstyle ':completion:*:manuals' separate-sections true
# zstyle ':completion:*' auto-description true
# zstyle ':completion:*:auto-describe' format 'specify: %d'

# Make the list prompt friendly
# zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

zstyle ':completion:*' last-prompt yes
# ## Listing behaviour
zstyle ':completion:*' list-grouped yes
# zstyle ':completion:*' list-packed yes

# ## Show more information for matches
zstyle ':completion:*' file-list always
zstyle ':completion:*' strip-comments false

zstyle ':completion:*:*:*:*:processes' command 'ps -u ${USER} -o pid,user,command'
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-_]#)*=0=01;34=02=0'
zstyle ':completion:*:*:*:*:processes-names' command  'ps -c -u ${USER} -o command | uniq'

zstyle ':completion:*:kill:*' force-list always

zstyle ':completion:*:killall:*' command 'ps -u $USER -o command'

################
### COMPLETION UTILS
################

function tab-key-press {

  if [[ -z $BUFFER ]]; then # on empty cli
    # complete executables for current direcotry
    BUFFER+="./"
    CURSOR+=2
    zle list-choices
  else
    # adds '...' during completion to cli
    echo -n "${fg_bold[cyan]}...$reset_color"
    zle expand-or-complete # default binding
    zle reset-prompt
  fi
}
zle -N tab-key-press
bindkey '^I' tab-key-press # '^I' is <Tab>

zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
zstyle ':completion:hist-complete:*' force-list always
bindkey '^H' hist-complete # '^H' is ctrl + H
