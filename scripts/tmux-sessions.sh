#!/usr/bin/env bash

set -euo pipefail

pick_session() {
    tmux list-sessions \
        -F "#{session_name}" \
        -f "#{?#{m/r:-popup$,#{session_name}},0,1}" | fzf -q "${1}"
}

if [[ -z $TMUX ]]; then
    echo >&2 "Only able to run in tmux"
    exit 1
fi

SESSION="$(pick_session "${1:-}")"
tmux switch-client -t "${SESSION}"
