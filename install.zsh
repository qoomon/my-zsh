#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

autoload +X -U colors && colors

function ask {
  read -p "$1 " response
  [[ $response == "y" || $response == "Y" || $response == "yes" || $response == "Yes" ]]
}

ZSHRC_FILE="$HOME/.zshrc"

ZSHCONF_DIR="$(pwd | sed "s|^$HOME|\${HOME}|")"

ZSHRC_FILE_COMMAND="test -e \"$ZSHCONF_DIR/zconfig.zsh\" && source \"$ZSHCONF_DIR/zconfig.zsh\""

if grep -xq "$ZSHRC_FILE_COMMAND" "$ZSHRC_FILE" >/dev/null; then
  echo "zconfig already installed to $ZSHRC_FILE"
else
  echo "zconfig install to $ZSHRC_FILE"
  {echo "$ZSHRC_FILE_COMMAND\n"; cat "$ZSHRC_FILE"} | tee "$ZSHRC_FILE" >/dev/null;
fi

USER=${USER:-$(whoami)}
if [ "$(uname)" = "Darwin" ]; then
  CURRENT_USER_SHELL=$(dscl . -read /Users/$USER | grep UserShell | cut -d' ' -f2)
else
  CURRENT_USER_SHELL=$(getent passwd $USER | cut -d':' -f7)
fi
if [ "$CURRENT_USER_SHELL" = "/bin/zsh" ]; then
  echo "user shell already is /bin/zsh"
elif ask "Want to change shell for current user?"; then
  if ! grep -xq "/bin/zsh" "/etc/shells"; then
    echo "/bin/zsh" >> "/etc/shells"
  fi
  chsh -s /bin/zsh
fi
