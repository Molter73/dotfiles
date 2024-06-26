#!/usr/bin/env bash

NAME=$1
shift
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
