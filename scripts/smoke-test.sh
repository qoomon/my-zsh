#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT

echo "== install.zsh non-interactive run =="
HOME="$tmp_home" MY_ZSH_INSTALL_CHANGE_SHELL=never zsh "$repo_root/install.zsh"
grep -q 'source ".*\/zshrc.zsh"' "$tmp_home/.zshrc"

echo "== command usage checks =="
if bash "$repo_root/commands/transfer" >/dev/null 2>&1
then
  echo "transfer should fail without args" >&2
  exit 1
fi

if bash "$repo_root/commands/convert-pdf2images" >/dev/null 2>&1
then
  echo "convert-pdf2images should fail without args" >&2
  exit 1
fi

if bash "$repo_root/commands/docker-registry-image-tags" >/dev/null 2>&1
then
  echo "docker-registry-image-tags should fail without args" >&2
  exit 1
fi

if bash "$repo_root/commands/gauth" >/dev/null 2>&1
then
  echo "gauth should fail without args" >&2
  exit 1
fi

echo "Smoke tests passed."
