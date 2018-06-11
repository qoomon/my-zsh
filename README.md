# zsh-config 🐚	⚙️
## Installation
* `git clone --depth 1 https://github.com/qoomon/zsh_config.git "$HOME/.zsh"`
* `$HOME/.zsh/install.zsh`
  * installs this config for current user

### Optional
* `install_utils_macos.sh`  - install common command line utils (with brew)

## Plugins

* [zsh-config](https://github.com/qoomon/zsh-config/blob/master/utils/zconfig.zsh)
  * `zconfig cd` - cd to $ZCONFIG_HOME
  * `zconfig edit [EDITOR]` - open config in $EDITOR or in given editor
  * `zconfig update` - updates config an [zgem](https://github.com/qoomon/zgem) plugins
* [zjump](https://github.com/qoomon/zjump.git)
  * `j` - directory history search with fzf
* [zsh-history-search](https://github.com/qoomon/zsh-history-search.git)
  * `ctrl + R` - command history search with fzf
  * `ctrl` + `SPACE` - command argument history search with fzf
 * [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search.git) 
 * `UP/DOWN` - circle through command history and filter by current command line 
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
* [zsh-completions](https://github.com/zsh-users/zsh-completions.git)

### Prompt
* Multiline Prompt
* Root user highlight
* GIT status of current directory
  * `*` dirty flag
  * `⇡`/`⇣` before/behind
* Return code after command, if it's not `0`

![prompt_default](docs/prompt_default.png)

![prompt_root](docs/prompt_root.png)

![prompt_error](docs/prompt_error.png)



## Zsh Wiki

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
* `vared <VARIABLE>` On-the-fly editing of `<VARIABLE>`
* `!!`	              Execute last command in history
* `!<PEFIX>`	        Execute last command in history beginning with `<PEFIX>`
* `!<PEFIX>:p`      	Print last command in history beginning with `<PEFIX>`

### sources
* http://www.rayninfo.co.uk/tips/zshtips.html
* http://grml.org/zsh/zsh-lovers.html
* http://www.bash2zsh.com/zsh_refcard/refcard.pdf
* http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html
