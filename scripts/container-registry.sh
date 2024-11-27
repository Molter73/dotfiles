#!/usr/bin/env bash

# This script creates a persistent image registry to be used (mostly) with
# kind.

set -euo pipefail

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
}

function delete() {
    registry_name="$1"
    if ! registry_exists "${registry_name}"; then
        echo "Registry is not created, nothing to be done"
        exit
    fi

    podman rm -f "${registry_name}"
}
