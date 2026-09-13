#!/bin/zsh
set -e

SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

autoload -Uz colors && colors

function ask {
  if [[ ! -t 0 ]]
  then
    return 1
  fi
  echo -n "$1 "
  local response && read response
  [[ $response == "y" || $response == "Y" || $response == "yes" || $response == "Yes" ]]
}

function user_shell {
  if [[ "$(uname)" == "Darwin" ]]
  then
    dscl . -read /Users/${USER:-$(whoami)} | grep UserShell: | cut -d' ' -f2
  else
    getent passwd ${USER:-$(whoami)} | cut -d':' -f7
  fi
}


ZSHRC_FILE="$HOME/.zshrc"

ZSHCONF_DIR="$(pwd | sed "s|^$HOME|\${HOME}|")"

ZSHRC_FILE_COMMAND="source \"$ZSHCONF_DIR/zshrc.zsh\""

if grep -xq "$ZSHRC_FILE_COMMAND" "$ZSHRC_FILE" 2>/dev/null
then
  echo "my-zsh config already installed to $ZSHRC_FILE"
else
  echo "install my-zsh config to $ZSHRC_FILE"
  touch "$ZSHRC_FILE"
  {echo "$ZSHRC_FILE_COMMAND\n" && cat "$ZSHRC_FILE"} | tee "$ZSHRC_FILE" >/dev/null;
fi

target_shell="$(command -v zsh || true)"
if [[ -z "$target_shell" ]]
then
  echo "zsh is not installed or not in PATH" >&2
  exit 1
fi
target_shell_dir="$(cd "$(dirname "$target_shell")" && pwd -P)"
target_shell="${target_shell_dir}/$(basename "$target_shell")"
target_shell_name="$(basename "$target_shell")"

change_shell="${MY_ZSH_INSTALL_CHANGE_SHELL:-ask}"
if [[ "$change_shell" == 'always' ]]
then
  change_shell='yes'
elif [[ "$change_shell" == 'never' ]]
then
  change_shell='no'
fi

if [[ $(user_shell) = "$target_shell" ]]
then
  echo "user shell already set to $target_shell"
elif [[ "$change_shell" == 'yes' ]] || ([[ "$change_shell" == 'ask' ]] && ask "Want to change shell for current user?")
then
  if ! grep -xq "$target_shell" "/etc/shells" && ! grep -Eq ".*/${target_shell_name}$" "/etc/shells"
  then
    echo "Shell '$target_shell' is not listed in /etc/shells." >&2
    echo "Please add it with elevated privileges, then run:" >&2
    echo "  chsh -s $target_shell" >&2
    exit 1
  fi
  chsh -s "$target_shell"
else
  echo "skip changing user shell (set MY_ZSH_INSTALL_CHANGE_SHELL=always|never to control this)"
fi
