#!/usr/bin/env bash

set -uo pipefail

pick_session() {
    tmux list-sessions \
        -F "#{session_name}" \
        -f "#{?#{m/r:-popup$,#{session_name}},0,1}" \
        | fzf \
            --tmux "75%" \
            --reverse \
            --border=double \
            --border-label=" sessions " \
            --border-label-pos=10 \
            -q "${1}"
}

if [[ -z $TMUX ]]; then
    echo >&2 "Only able to run in tmux"
    exit 1
fi

# If we are running in a popup window, we need to detach (hide it) first
SESSION_NAME="$(tmux display-message -p -F "#{session_name}")"
if [[ "${SESSION_NAME}" =~ -popup$ ]]; then
    tmux detach-client
fi

SESSION="$(pick_session "${1:-}")"
if [[ -z "${SESSION:-}" ]]; then
    exit 0
fi

tmux switch-client -t "${SESSION}"
