#!/usr/bin/env bash

set -xeuo pipefail

WORKDIR="${1:-$PWD}"

if ! podman image exists quay.io/mmoltras/devcontainers:devc ; then
    echo >&2 "Devcontainer image not found, build it first"
    return 1
fi

container_name="$(basename "$WORKDIR" | tr . -)-devcontainer"
if [[ "$WORKDIR" == "$HOME/worktrees"* ]]; then
    # worktrees will have a session name holding the project name and
    # its subdirectory to prevent collisions
    project="$(basename "$(dirname "$WORKDIR")")"
    branch="$(basename "$WORKDIR")"
    container_name="${project}-${branch}-devcontainer"
fi

cargo_cache="$(dirname "$WORKDIR")/target"

if ! podman container exists "$container_name" ; then
    podman run --rm -id --name "$container_name" \
        -v "$WORKDIR:$WORKDIR" \
        -v "/run/podman/podman.sock:/run/podman/podman.sock" \
        -v "/var/run/docker.sock:/var/run/docker.sock" \
        -v "cargo-cache:$cargo_cache" \
        -e "CARGO_TARGET_DIR=$cargo_cache" \
        -w "$WORKDIR" \
        --privileged \
        quay.io/mmoltras/devcontainers:devc
fi

podman exec -it "$container_name" zsh
