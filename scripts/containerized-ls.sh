#!/usr/bin/env bash

# Derive the container name from the basename of the git repo containing the
# current working directory, falling back to the cwd's basename otherwise.
GIT_ROOT=$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)
NAME=$(basename "${GIT_ROOT:-$PWD}")

# falcosecurity/libs project will be handled by the falco devcontainer
if [[ "$NAME" == "libs" ]]; then
    NAME="falco"
fi

DEVCONTAINER="devcontainers-${NAME}-builder"

# Verify that a container by this name actually exists, and is running
if podman container exists "${DEVCONTAINER}"; then
    # Important part here is both the '-i' and the redirection of STDERR
    podman exec -i "${DEVCONTAINER}" "$@"
elif docker ps | grep -q "$DEVCONTAINER"; then
    docker exec -i "$DEVCONTAINER" "$@"
else
    exec "$@"
fi
