# my ZSH <sub>[🌊🐚]</sub>

<img width="767" alt="prompt_example" src="https://github.com/qoomon/my-zsh/assets/3963394/75aec48b-7c98-47db-8806-75e3473f0766">

<p align="right"><sub><sup>Terminal - [iTerm2](https://iterm2.com/), Color Theme - [qoomon](https://raw.githubusercontent.com/qoomon/zsh-theme-qoomon/master/qoomon.itermcolors)</sup></sub></p>

## Features
* Colored Prompt
  * [qoomon Theme](https://github.com/qoomon/zsh-theme-qoomon.git)
    * Display Exit Code if not 0
    * Display Git informations of working directory (Branch name and Status Indicators)
  * [Syntax Highlighting Plugin](https://github.com/zsh-users/zsh-syntax-highlighting.git)
* Completions
  * [fzf-tab](https://github.com/Aloxaf/fzf-tab) fzf completion; hit `Tab`
  * [zsh-history-search](https://github.com/qoomon/zsh-history-search.git) history fzf completion; hit `Ctrl` + `Space`
* Search History
  * by Substrings; hit `Arrow Up`
  * Improved Version of Reverse History Search; search with [fzf](https://github.com/junegunn/fzf#installation); hit `Ctrl` + `R`
* Jump to visited Directories with [zjump](https://github.com/qoomon/zjump.git); command `j <PART_OF_DIR_PATH>...`
* Handy Util Functions and Aliases, see [`modules/general.zsh`](modules/general.zsh)
* [Config Plugin](https://github.com/qoomon/zconfig)
  * `zconfig cd` - cd to `$ZCONFIG_HOME`
  * `zconfig edit [EDITOR]` - open config in `$EDITOR` or in given editor
  * `zconfig update` - updates config and [zgem](https://github.com/qoomon/zgem) plugins
* Handy optional Utils, see [Utils Directory](utils/); load all by `zgem bundle` or specific util by `zgem bundle <UTIL_NAME>`
* and a lot more..., see [Configuration Modules](#modules)


## Installation
* [Install zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH#how-to-install-zsh-in-many-platforms)
* [Install fzf](https://github.com/junegunn/fzf#installation), it's mandatory to make following [plugins](#plugins) work
  * [zjump](https://github.com/qoomon/zjump.git)
  * [zsh-history-search](https://github.com/qoomon/zsh-history-search.git)
  * [fzf-tab](https://github.com/Aloxaf/fzf-tab)
* Install [my-zsh](https://github.com/qoomon/my-zsh)
  * `git clone --depth 1 https://github.com/qoomon/my-zsh.git "$HOME/.zsh" && $HOME/.zsh/install.zsh`
* Install qoomon Colors Scheme [optional]
  * for [iTerm](https://raw.githubusercontent.com/qoomon/zsh-theme-qoomon/master/qoomon.itermcolors)
  * for [macOS Terminal](https://raw.githubusercontent.com/qoomon/zsh-theme-qoomon/master/qoomon.terminal)


## Configuration Structure
Entrypoint [`zshrc.zsh`](zshrc.zsh)

#### Modules
* [`modules/plugins.zsh`](modules/plugins.zsh)
* [`modules/general.zsh`](modules/general.zsh)
* [`modules/history.zsh`](modules/history.zsh)
* [`modules/completions.zsh`](modules/completions.zsh)

##### Plugins
* [zconfig](https://github.com/qoomon/zconfig)
* [zjump](https://github.com/qoomon/zjump.git)
  * `j` - directory history search with [fzf](https://github.com/junegunn/fzf)
* [zsh-history-search](https://github.com/qoomon/zsh-history-search.git)
  * `ctrl + R` - command history search with [fzf](https://github.com/junegunn/fzf)
  * `ctrl` + `SPACE` - command argument history search with [fzf](https://github.com/junegunn/fzf)
 * [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search.git)
 * `UP/DOWN` - circle through command history and filter by current command line
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
* [zsh-completions](https://github.com/zsh-users/zsh-completions.git)
* [zsh-theme-qoomon](https://github.com/qoomon/zsh-theme-qoomon.git)
* [zsh-lazyload](https://github.com/qoomon/zsh-lazyload)
  * e.g. `lazyload nvm -- 'source "$(brew --prefix nvm)/nvm.sh"'`

## Misc Zsh Know-How

### Shortcuts

* `CTRL + A`	Move to the beginning of the line
* `CTRL + E`	Move to the end of the line
* `CTRL + [left arrow]`	Move one word backward (on some systems this is `ALT + B`)
* `CTRL + [right arrow]`	Move one word forward (on some systems this is `ALT + F`)

* `CTRL + X`  -> `CTRL + E` Edit command line within $EDITOR
* `CTRL + _` Undo last input
* `CTRL + K` Clear the characters on the line after the current cursor position
* `CTRL + U` Clear the entire line
* `ESC  + [backspace]` or `CTRL + W` Delete the word in front of the cursor
* `ESC  + D` Delete the word after the cursor
* `CTRL + W` delete last word

* `ESC  + Q` Push current line on a stack until next command line

* `CTRL + C` Terminate/kill current foreground process
* `CTRL + Z` Suspend/stop current foreground process
 * `fg` Run process again in foreground
 * `bg` Run process again in background
* `CTRL + S` Stop output to screen
* `CTRL + Q` Re-enable screen output

* `ESC  + H` Open man page for current command

* `CTRL + R` Search history
* `CTRL + G` Escape from search mode

* `CTRL + L` Clear screen


### Commands
* `vared <VARIABLE>` On-the-fly editing of `<VARIABLE>`
* `!!`               Execute last command in history
* `!<PEFIX>`         Execute last command in history beginning with `<PEFIX>`
* `!<PEFIX>:p`       Print last command in history beginning with `<PEFIX>`


---
**Sources**
* http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/
* http://www.rayninfo.co.uk/tips/zshtips.html
* http://grml.org/zsh/zsh-lovers.html
* http://www.bash2zsh.com/zsh_refcard/refcard.pdf
* http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html
