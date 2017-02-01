# sudo with loaded .zshrc and co.
function sudome  {

  local index=0;
  for arg in ${@}; do
    if [[ "$arg" != "-"* ]]; then
      break
    fi
    index=$(expr $index + 1)
  done

  local -a args; args=(${@:1:$index})
  local -a cmd; cmd=(${@:$(expr $index + 1)})

  ( sudo -E $args zsh -ic "${cmd}" )
}
type compdef >/dev/null && compdef _sudo sudome # set default completion
