#!/usr/bin/env bash

set -o pipefail

pick_dir() {
    fd . "${GOPATH}/src/" --type d --max-depth 3 --min-depth 3 \
        | fzf \
            --tmux "75%" \
            --reverse \
            --border=double \
            --border-label=" repos " \
            --border-label-pos=10 \
            --preview="[ -f {}README.md ] && bat \
                --color=always \
                --wrap=never \
                --style=numbers \
                {}README.md || echo 'No README'" \
            -q "$1"
}

new_session() {
    tmux new-session -ds "$1" -c "$2"
    tmux send-keys -t "${1}:1" "nvim ." Enter
    tmux new-window -dt "${1}" -c "${2}"
    tmux split-window -dt "${1}:2" -h -c "${2}"
    tmux split-window -dt "${1}:2.1" -v -c "${2}"
    tmux send-key -t "${1}:2.1" "htop" Enter
}

DIR="$(pick_dir "${1:-}")"
if [[ -z $DIR ]]; then
    exit 0
fi

selected_name=$(basename "$DIR" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $tmux_running ]]; then
    new_session "$selected_name" "$DIR"
    tmux attach -t "$selected_name"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    new_session "$selected_name" "$DIR"
fi

if [[ -z $TMUX ]]; then
    # We are not in tmux, attach to the existing session
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
