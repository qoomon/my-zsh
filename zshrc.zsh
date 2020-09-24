ZCONFIG_HOME=$(dirname $0)

### Add Commands Directory To Path
path=("$ZCONFIG_HOME/commands" $path)

### Load Modules
source "$ZCONFIG_HOME/modules/general.zsh"
source "$ZCONFIG_HOME/modules/history.zsh"
source "$ZCONFIG_HOME/modules/completion.zsh"
source "$ZCONFIG_HOME/modules/plugins.zsh"
