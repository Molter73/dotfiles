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

if [[ -f "${HOME}/Pictures/claude.svg" ]]; then
    args+=("-i" "${HOME}/Pictures/claude.svg")
fi

notify-send "${args[@]}" \
    "CLAUDIO $SUMMARY" \
    "Session: $(tmux display-message -p '#S')"
