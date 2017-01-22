__zplug::http::check()
{
    local    repo="$1"
    local -A tags

    tags[use]="$(
    __zplug::core::core::run_interfaces \
        'use' \
        "$repo"
    )"


    [[ -e $tags[use] ]]

    return $status
}

__zplug::http::install() {
    local    repo="$1"
    local -A tags

    tags[use]="$(
    __zplug::core::core::run_interfaces \
        'use' \
        "$repo"
    )"

    tags[as]="$(
    __zplug::core::core::run_interfaces \
        'as' \
        "$repo"
    )"


    curl -O "$1"
  

    return $status
}

__zplug::http::load_plugin() {
    local    repo="$1"
    local -A tags
    local -A default_tags
    local -a unclassified_plugins

    # Unused here, but can be useful in some cases
    local -a load_fpaths
    local -a load_plugins
    local -a nice_plugins
    local -a lazy_plugins

    __zplug::core::tags::parse "$repo"
    tags=( "${reply[@]}" )
    default_tags[use]="$(__zplug::core::core::run_interfaces 'use')"

    if [[ $tags[use] == $default_tags[use] ]]; then
        tags[use]="$HOME/boo.zsh"
    fi

    unclassified_plugins=( \
        __zplug::utils::shell::expand_glob "${tags[use]}" \
    )

    reply=()
    [[ -n $unclassified_plugins ]] && reply+=( unclassified_plugins "${(F)unclassified_plugins}" )

    return $status
}
