#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

autoload -Uz colors && colors

function ask {
  echo -n "$1 "
  local response && read response
  [[ $response == "y" || $response == "Y" || $response == "yes" || $response == "Yes" ]]
}

function usershell {
  if [[ "$(uname)" == "Darwin" ]]; then
    dscl . -read /Users/${USER:-$(whoami)} | grep UserShell: | cut -d' ' -f2
  else
    getent passwd ${USER:-$(whoami)} | cut -d':' -f7
  fi
}


ZSHRC_FILE="$HOME/.zshrc"

ZSHCONF_DIR="$(pwd | sed "s|^$HOME|\${HOME}|")"

ZSHRC_FILE_COMMAND="test -e \"$ZSHCONF_DIR/zshrc.zsh\" && source \"$ZSHCONF_DIR/zshrc.zsh\""

if grep -xq "$ZSHRC_FILE_COMMAND" "$ZSHRC_FILE" >/dev/null; then
  echo "zconfig already installed to $ZSHRC_FILE"
else
  echo "zconfig install to $ZSHRC_FILE"
  {echo "$ZSHRC_FILE_COMMAND\n"; cat "$ZSHRC_FILE"} | tee "$ZSHRC_FILE" >/dev/null;
fi


if [[ $(usershell) = "/bin/zsh" ]]; then
  echo "user shell already set to /bin/zsh"
elif ask "Want to change shell for current user?"; then
  if ! grep -xq "/bin/zsh" "/etc/shells"; then
    echo "/bin/zsh" >> "/etc/shells"
  fi
  chsh -s /bin/zsh
fi
