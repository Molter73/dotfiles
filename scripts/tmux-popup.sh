#!/usr/bin/env bash

width=${2:-75%}
height=${2:-75%}
SESSION_NAME="$(tmux display-message -p -F "#{session_name}")"
if [[ "${SESSION_NAME}" =~ -popup$ ]]; then
    tmux detach-client
else
    tmux popup \
        -d '#{pane_current_path}' \
        -xC -yC -w"$width" -h"$height" \
        -E "tmux attach -t '${SESSION_NAME}-popup' || tmux new -s '${SESSION_NAME}-popup'"
fi
