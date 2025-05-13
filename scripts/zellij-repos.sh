#!/usr/bin/env bash

set -o pipefail

pick_dir() {
    fd . "${GOPATH}/src/" --type d --max-depth 3 --min-depth 3 | fzf -q "$1"
}

DIR="$(pick_dir "${1:-}")"

if [[ -z $DIR ]]; then
    exit 0
fi

selected_name=$(basename "$DIR" | tr . _)

if [[ -z "${ZELLIJ}" ]]; then
    # Not running inside zellij, attach
    zellij attach -c "$selected_name" \
        options --default-cwd "$DIR"
else
    # Running inside zellij, create session in background and notify
    zellij attach -b "$selected_name" \
        options --default-cwd "$DIR"
    echo "Created session $selected_name, switch to it with the manager"
fi
