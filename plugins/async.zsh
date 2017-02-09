zmodload zsh/zpty

ASYNC_VERBOSE="${ASYNC_VERBOSE:-false}"

_async_queue=()

_async_worker_name='async_worker'

function _async_worker {
  while read -r -d $'\0'; do
    printf $'\0'
  done
}

function _async_callback {
  zpty -r "$_async_worker_name"
  local cmd="${_async_queue[1]}"
  shift _async_queue
  $ASYNC_VERBOSE && echo "${fg_bold[blue]}[async]${reset_color} $cmd"
  eval "$cmd"
}

function async {
	_async_queue+="${(j: :)@}"
  zpty -w "$_async_worker_name" $'\0'
}

zpty -b "$_async_worker_name" _async_worker -p $$
zle -F $REPLY _async_callback
