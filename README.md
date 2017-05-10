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

* `CTRL + A`	Move to the beginning of the line
* `CTRL + E`	Move to the end of the line
* `CTRL + [left arrow]`	Move one word backward (on some systems this is `ALT + B`)
* `CTRL + [right arrow]`	Move one word forward (on some systems this is `ALT + F`)

* `CTRL + X`  -> `CTRL + E` Edit commandline within $EDITOR
* `CTRL + _` Undo last input
* `CTRL + K`	Clear the characters on the line after the current cursor position
* `CTRL + U` Clear the entire line
* `ESC  + [backspace]` or `CTRL + W`	Delete the word in front of the cursor
* `ESC  + D`	Delete the word after the cursor

* `ESC  + Q` Push current line on a stack untli next commandline

* `CTRL + C`	Terminate/kill current foreground process
* `CTRL + Z`	Suspend/stop current foreground process
 * `fg` Run process again in foreground
 * `bg` Run process again in background
* `CTRL + S`	Stop output to screen
* `CTRL + Q`	Re-enable screen output

* `ESC  + H` Open man page for current command

* `CTRL + R`	Search history
* `CTRL + G`	Escape from search mode

* `CTRL + L`	Clear screen



## Commands
* `vared <VARIABLE>` On-the-fly editing of variable
* `!!`	              Execute last command in history
* `!<PEFIX>`	        Execute last command in history beginning with `<PEFIX>`
* `!<PEFIX>:p`      	Print last command in history beginning with `<PEFIX>`

### sources
* http://www.rayninfo.co.uk/tips/zshtips.html
* http://grml.org/zsh/zsh-lovers.html
* http://www.bash2zsh.com/zsh_refcard/refcard.pdf
* http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html
