# 🐚 zsh_config 🐚
## Installation
* git clone --depth 1 https://github.com/qoomon/zsh_config.git "$HOME/.zsh"
* $HOME/.zsh/install.zsh
  * install this config for current user

### Optional
* install_utils_macos.sh  - install common command line utils (with brew)

## Commands
zconfig edit - will open config in $EDITOR


## Zsh Knowledge

## Shortcuts
* pause process: CTRL + Z
 * 'fg' command: run process again in foreground
 * 'bg' command: run process again in background
* open man page for current command : esc + h
* edit commandline within $EDITOR : ctrl + x  -> ctrl + e

* CTRL + A	Move to the beginning of the line
* CTRL + E	Move to the end of the line
* CTRL + [left arrow]	Move one word backward (on some systems this is ALT + B)
* CTRL + [right arrow]	Move one word forward (on some systems this is ALT + F)
* CTRL + U (bash)	Clear the characters on the line before the current cursor position
* CTRL + U (zsh)	If you're using the zsh, this will clear the entire line
* CTRL + K	Clear the characters on the line after the current cursor position
* ESC + [backspace]	Delete the word in front of the cursor
* CTRL + W	Delete the word in front of the cursor
* ALT + D	Delete the word after the cursor
* CTRL + R	Search history
* CTRL + G	Escape from search mode
* CTRL + _	Undo the last change
* CTRL + L	Clear screen
* CTRL + S	Stop output to screen
* CTRL + Q	Re-enable screen output
* CTRL + C	Terminate/kill current foreground process
* CTRL + Z	Suspend/stop current foreground process

## Commands
* On-the-fly editing of variables : vared <VARIABLE>
* !!	Execute last command in history
* !abc	Execute last command in history beginning with abc
* !abc:p	Print last command in history beginning with abc

### sources
* http://www.rayninfo.co.uk/tips/zshtips.html
* http://grml.org/zsh/zsh-lovers.html
* http://www.bash2zsh.com/zsh_refcard/refcard.pdf
* http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html
