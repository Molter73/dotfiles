#!/usr/bin/env bash

# The name of the container to run `clangd` in must be passed as the first and only argument
#
# This is based off the name of the buffer and the repository, etc. it is in, so even if we
# don't end up attaching to a container, it will still be passed
[ "$#" -ne 1 ] && echo "Container name required as first and only argument" >&2 && exit 1

NAME=$1
NPROC="$(nproc)"
DEVCONTAINER="devcontainers-${NAME}-builder"

# Verify that a container by this name actually exists, and is running
if ! podman container exists "${DEVCONTAINER}"; then
    clangd --background-index --clang-tidy -j "${NPROC}"
else
    NPROC="$(podman exec "${DEVCONTAINER}" nproc)"
    # Important part here is both the '-i' and the redirection of STDERR
    podman exec -i "${DEVCONTAINER}" /usr/bin/clangd -j "${NPROC}" --background-index --clang-tidy 2>/dev/null
fi
