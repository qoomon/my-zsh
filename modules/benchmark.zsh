function zshrc_benchmark {
  local repeatCount=${1:-10}
  repeat $repeatCount time zsh -ic exit
}
