#!/usr/bin/env bash

source "${GOPATH}/src/github.com/molter73/dotfiles/scripts/container-registry.sh"

if (($# == 0)); then
    echo >&2 "At least one parameter must be supplied"
    usage
    exit 1
fi

METHOD="${1:-}"
shift

case "${METHOD}" in
    "create")
        create "${REGISTRY_NAME}" "${REGISTRY_PORT}"
        ;;
    "delete")
        delete "${REGISTRY_NAME}"
        ;;
    "reconnect")
        reconnect "${REGISTRY_PORT}"
        ;;
    *)
        echo >&2 "Unknown option '${METHOD}'"
        exit 1
        ;;
esac
