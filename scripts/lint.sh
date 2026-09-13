#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
zsh_bin="${ZSH_BIN:-/bin/zsh}"
if [ ! -x "$zsh_bin" ]
then
  zsh_bin="$(command -v zsh || true)"
fi
if [ -z "$zsh_bin" ]
then
  echo "zsh not found in /bin/zsh or PATH" >&2
  exit 1
fi

mapfile -t bash_scripts < <(find "$repo_root/commands" -maxdepth 1 -type f -print)
mapfile -t zsh_scripts < <(find "$repo_root" -maxdepth 2 -type f \( -path "$repo_root/modules/*.zsh" -o -path "$repo_root/utils/*.zsh" -o -name 'install.zsh' -o -name 'zshrc.zsh' \) -print)

echo "== Bash syntax check =="
for file in "${bash_scripts[@]}"
do
  if head -n1 "$file" | grep -Eq 'bash'
  then
    bash -n "$file"
  fi
done

echo "== Zsh syntax check =="
for file in "${zsh_scripts[@]}"
do
  "$zsh_bin" -n "$file"
done

if command -v shellcheck >/dev/null 2>&1
then
  echo "== ShellCheck =="
  for file in "${bash_scripts[@]}"
  do
    if head -n1 "$file" | grep -Eq 'bash'
    then
      shellcheck -x "$file"
    fi
  done
else
  echo "shellcheck not found; skipping ShellCheck (install shellcheck to enable linting)." >&2
fi

echo "Lint checks passed."
