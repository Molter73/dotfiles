super_image() {
    image=$(docker images | sed 1d | grep -v '<none>' | fzf -q "$1" | awk '{print $1 ":" $2}')
    tempfile="$(mktemp)"
    podman save -o "$tempfile" "$image"
    sudo podman import "$tempfile" "$image"
    rm -f "$tempfile"
}
