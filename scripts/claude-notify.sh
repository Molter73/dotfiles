#!/usr/bin/env bash

set -euo pipefail

function die() {
    echo >&2 "$1"
    exit 1
}

if [[ $# -gt 1 ]]; then
    die "Invalid number of arguments"
fi

OP="${1:-wait}"

case "${OP}" in
    stop)
        SUMMARY="HA CONCLUIDO"
        ;;
    wait)
        SUMMARY="ESPERA"
        ;;
    *)
        die "Invalid option: $OP"
        ;;
esac

args=()

# Get session info - try tmux first, fallback to PWD
if command -v tmux &> /dev/null && tmux display-message -p '#S' &> /dev/null; then
    BODY="Session: $(tmux display-message -p '#S')"
else
    BODY="Directory: $(basename "${PWD}")"
fi

notify-send "${args[@]}" \
    "CLAUDIO $SUMMARY" \
    -i "${HOME}/Pictures/claude.svg" \
    "$BODY"
