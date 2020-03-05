cd $(dirname "$0")
ZCONFIG_HOME=$PWD

### Add Commands Directory To Path
path+="$ZCONFIG_HOME/commands"

### modules
source "modules/general.zsh"
source "modules/history.zsh"
source "modules/completion.zsh"
source "modules/alias.zsh"
source "modules/plugins.zsh"
