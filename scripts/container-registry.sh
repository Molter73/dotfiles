#!/usr/bin/env bash

# This script creates a persistent image registry to be used (mostly) with
# kind. Because my podman environment is in a remote machine, it creates an
# ssh tunnel to it, so it can be used transparently.

set -euo pipefail

REGISTRY_CONTROL_SOCKET="${HOME}/.config/kind/registry.sock"
REGISTRY_NAME="${REGISTRY_NAME:-kind-registry}"
REGISTRY_PORT="${REGISTRY_PORT:-5001}"

function registry_exists() {
    registry_name="$1"

    [ "$(podman inspect -f '{{.State.Running}}' "${registry_name}" 2> /dev/null || true)" == "true" ]
}

function create() {
    registry_name="$1"
    registry_port="$2"

    if registry_exists "${registry_name}"; then
        echo "Registry already exists"
        exit 1
    fi

    podman run -d --restart=always \
        -p "127.0.0.1:${registry_port}:5000" \
        --name "${registry_name}" \
        -v "${registry_name}-volume:/var/lib/registry:Z" \
        --network bridge \
        registry:2
    ssh -fNTMS "${REGISTRY_CONTROL_SOCKET}" -L "$registry_port:127.0.0.1:$registry_port" remote
}

function delete() {
    registry_name="$1"
    if ! registry_exists "${registry_name}"; then
        echo "Registry is not created, nothing to be done"
        exit
    fi

    podman rm -f "${registry_name}"
    ssh -S "${REGISTRY_CONTROL_SOCKET}" -O exit remote
}

function reconnect() {
    ssh_socket="$1"
    port="$2"

    if [[ -f "${ssh_socket}" ]]; then
        ssh -S "${ssh_socket}" -O exit remote
    fi

    ssh -fNTMS "${ssh_socket}" -L "$port:127.0.0.1:$port" remote
}

