# Completions ##################################################################
# see http://zsh.sourceforge.net/Doc/Release/Completion-System.html
# Layout is :completion:FUNCTION:COMPLETER:COMMAND-OR-MAGIC-CONTEXT:ARGUMENT:TAG
autoload -Uz colors && colors
ZSH_COMPLETION_DIR='/usr/local/share/zsh/site-functions'
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
autoload -Uz compinit
if [ $ZSH_COMPDUMP(Nmh-24) ]
then # check for recent compdump file within last 24h
  compinit -C # -C do not validate cache
else
  rm -f $ZSH_COMPDUMP
  compinit
fi

# zstyle ':completion:*' use-cache on
# zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
# zstyle ':completion::complete:paket:add:*' use-cache off # disable cache for specific command e.g. paket add

################
### COMPLETION SETUP
################

## Options
# see http://www.cs.elte.hu/zsh-manual/zsh_16.html
setopt auto_list
setopt auto_menu # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
# setopt extended_glob
setopt null_glob # prevents an error in case a glob does not match any name
setopt numeric_glob_sort
setopt no_case_glob # Case insensitive globbing
# setopt no_clobber # disable overwrite file with redirection '>' force ovewrite with '>|'
# setopt correct # misspelled command correction sugestions

LISTMAX=0 # Only ask before displaying completions if doing so would scroll.
ZLE_SPACE_SUFFIX_CHARS=$'&|' # do not remove space after completion for '&' and '|'

# list of completers to use
# zstyle ':completion:*' completer      _complete _expand _list _match _prefix

# zstyle ':completion:*'                verbose yes # show descriptions for command options
# zstyle ':completion:*'                extra-verbose yes # show descriptions for commands

zstyle ':completion:*'                 matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'  # Case-Insensitive Completion

zstyle ':completion:*'                 squeeze-slashes true # consecutive slashes will be treated as a single slash
zstyle ':completion:*'                 accept-exact '*(N)' # forces prefix matching
zstyle ':completion:*'                 select-prompt '%Sat %p%s' # Add position hint to prompt when there are a lot of choices
zstyle ':completion:*'                 force-list always # always show comletion also if not ambiguous
zstyle ':completion:*'                 list-separator '--' # seperator between completion and description
zstyle ':completion:*'                 group-name '' # group matches by tag
zstyle ':completion:*:*:-command-:*:*' file-patterns '*(#q-*):executables:executable\ file *(-/):directories:directory' # list executables before directories


zstyle ':completion:*'                 ignored-patterns '_*'

zstyle ':completion:*:options'         description 'yes'
zstyle ':completion:*:options'         auto-description 'specify: %d'
zstyle ':completion:*:descriptions'    format '%F{yellow}❬%B%d%b%F{yellow}❭%f' # enable and format completion groups
zstyle ':completion:*:warnings'        format '%F{red}no matches%f' # enable and format no match
zstyle ':completion:*:messages'        format '%F{purple}%d%f'
# zstyle ':completion:*:corrections'     format '%U%F{green}%d (errors: %e)%f%u'

zstyle ':completion:*'                 special-dirs true
zstyle ':completion:*'                 ignore-parents parent pwd # cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*'                 list-dirs-first yes # list folders first on completion
zstyle ':completion:*'                 list-colors ${(s.:.)LS_COLORS} # colorize file system completion

### Menu behaviour
# zstyle ':completion:*'                 menu select # interactive # always show completions
# zstyle ':completion:*:default'         menu yes=0 select=0
zstyle ':completion:*:default'         menu select
zstyle ':completion:*:manuals'         separate-sections true
# zstyle ':completion:*'                 auto-description true
zstyle ':completion:*:auto-describe'   format 'specify: %d'

### Listing behaviour
# zstyle ':completion:*'                 list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s' # Make the list prompt friendly
zstyle ':completion:*'                 last-prompt yes
zstyle ':completion:*'                 list-grouped yes
# zstyle ':completion:*'                 list-packed yes
zstyle ':completion:*'                 file-list always
zstyle ':completion:*'                 strip-comments false

zstyle ':completion:*:*:*:*:processes'       command 'ps -u ${USER} -o pid,user,command'
zstyle ':completion:*:*:*:*:processes'       list-colors '=(#b) #([0-9]#) ([0-9a-z-_]#)*=0=01;34=02=0'
zstyle ':completion:*:*:*:*:processes-names' command  'ps -c -u ${USER} -o command | uniq'

zstyle ':completion:*:kill:*'                force-list always
zstyle ':completion:*:killall:*'             command 'ps -u $USER -o command'

zstyle ':completion:*'                       sort true
zstyle ':completion:*:git-checkout:*'        sort false # disable sort when completing `git checkout`

if [ ${commands[brew]} ]
then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

################
### COMPLETION UTILS
################

function __completion-widget {
  if [[ $BUFFER == '' || $BUFFER == '.' ]]
  then
    BUFFER="./"
    CURSOR=${#BUFFER}
  fi

  # adds '...' during completion to cli
  echo -n "${fg_bold[magenta]}…$reset_color"
  zle expand-or-complete # default binding
  zle reset-prompt
}
zle -N __completion-widget
bindkey '^I' __completion-widget # '^I' is <Tab>

################
### Extra COMPLETION for Commands
################

### gh (GitHub CLI )
if (( $+commands[gh] ))
then
    if [ ! "$ZSH_COMPLETION_DIR/_gh"(Nmh-24) ]
    then
        command gh completion --shell zsh >| "$ZSH_COMPLETION_DIR/_gh" &|
    fi
fi

### docker
if (( $+commands[docker] ))
then
    if [ ! "$ZSH_COMPLETION_DIR/_docker"(Nmh-24) ]
    then
        if [ -e '/Applications/Docker.app' ]
        then
            rm -rf "$ZSH_COMPLETION_DIR/_docker" && \
                ln -s '/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion'         "$ZSH_COMPLETION_DIR/_docker"
            rm -rf "$ZSH_COMPLETION_DIR/_docker-compose" && \
                ln -s '/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion' "$ZSH_COMPLETION_DIR/_docker-compose"
        else
            command docker completion zsh >| "$ZSH_COMPLETION_DIR/_docker" &|
        fi
    fi
fi
