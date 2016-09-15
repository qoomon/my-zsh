# WORKAROUND user zsh completion for z
function __z {
  local directories=($(_z 2>&1 | sed 's|^[^/]*||'))
  _describe 'visited directory' directories
  return 0
}
compdef __z _z
