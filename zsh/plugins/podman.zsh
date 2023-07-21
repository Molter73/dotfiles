super_image() {
    tempfile="$(mktemp)"
    podman save -o "$tempfile" "$1"
    sudo podman import "$tempfile" "$1"
    rm -f "$tempfile"
}
