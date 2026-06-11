super_image() {
    image=$(podman images | sed 1d | grep -v '<none>' | fzf -q "$1" | awk '{print $1 ":" $2}')

    if [[ -z "$image" ]]; then
        return 0
    fi

    podman save "$image" | sudo podman load
}
