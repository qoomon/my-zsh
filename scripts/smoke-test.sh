#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT

echo "== install.zsh non-interactive run =="
HOME="$tmp_home" MY_ZSH_INSTALL_CHANGE_SHELL=never "$zsh_bin" "$repo_root/install.zsh"
grep -q 'source ".*/zshrc.zsh"' "$tmp_home/.zshrc"

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

echo "== convert-pdf2scan cleanup check with stubs =="
tmp_bin="$(mktemp -d)"
trap 'rm -rf "$tmp_home" "$tmp_bin"' EXIT
cat > "$tmp_bin/identify" <<'EOF'
#!/usr/bin/env bash
echo 'page1'
EOF
cat > "$tmp_bin/convert" <<'EOF'
#!/usr/bin/env bash
last="${@: -1}"
touch "$last"
EOF
cat > "$tmp_bin/bc" <<'EOF'
#!/usr/bin/env bash
expr="$(cat)"
if [[ "$expr" =~ ^[[:space:]]*[0-9]+[[:space:]]*$ ]]; then
  echo "$expr" | tr -d '[:space:]'
elif grep -q 'page_count - 1' <<< "$expr"; then
  echo 0
elif [[ "$expr" =~ ^[[:space:]]*[0-9]+[[:space:]]*\+[[:space:]]*1[[:space:]]*$ ]]; then
  echo 1
elif grep -Eq 'page_index[[:space:]]*\+[[:space:]]*1' <<< "$expr"; then
  echo 1
else
  echo 0.03
fi
EOF
chmod +x "$tmp_bin/identify" "$tmp_bin/convert" "$tmp_bin/bc"
touch "$tmp_home/sample.pdf"
before_pdf2scan_dirs="$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'pdf2scan.*' -type d | sort || true)"
(cd "$tmp_home" && PATH="$tmp_bin:$PATH" bash "$repo_root/commands/convert-pdf2scan" sample.pdf)
test -f "$tmp_home/sample_scan.pdf"
(cd "$tmp_home" && PATH="$tmp_bin:$PATH" bash "$repo_root/commands/convert-pdf2scan" --gray sample.pdf)
test -f "$tmp_home/sample_scan.pdf"
after_pdf2scan_dirs="$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'pdf2scan.*' -type d | sort || true)"
if [ "$before_pdf2scan_dirs" != "$after_pdf2scan_dirs" ]
then
  echo "Temporary pdf2scan directories should be cleaned up" >&2
  exit 1
fi

echo "== gauth signal handling check with stubs =="
if PATH="/usr/bin:/bin" bash "$repo_root/commands/gauth" TESTSECRET >/dev/null 2>&1
then
  echo "gauth should fail when oathtool is unavailable" >&2
  exit 1
fi

cat > "$tmp_bin/oathtool" <<'EOF'
#!/usr/bin/env bash
echo '123456'
EOF
chmod +x "$tmp_bin/oathtool"
gauth_output="$tmp_home/gauth.out"
(PATH="$tmp_bin:$PATH" bash "$repo_root/commands/gauth" TESTSECRET >"$gauth_output" 2>&1) &
gauth_pid=$!
sleep 2
kill -TERM "$gauth_pid"
wait "$gauth_pid" || gauth_status=$?
gauth_status="${gauth_status:-0}"
if [ "$gauth_status" -ne 0 ]
then
  echo "gauth exited with unexpected status: $gauth_status" >&2
  exit 1
fi
grep -Eq '123456 [0-9]+s' "$gauth_output"

echo "Smoke tests passed."
