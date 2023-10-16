#!/usr/bin/env bash

# Change to a repo from anywhere

pick_dir() {
    fd . "${GOPATH}/src/" --type d --max-depth 3 --min-depth 3 | fzf -q "$1"
}

fd_repos() {
    DIR="$(pick_dir "$1")"

    if [[ -z $DIR ]]; then
        return 0
    fi

    cd "$DIR" || return 1
}

tmux_repos() {
    DIR="$(pick_dir "$1")"

    if [[ -z $DIR ]]; then
        return 0
    fi

    selected_name=$(basename "$DIR" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $tmux_running ]]; then
        tmux new-session -s "$selected_name" -c "$DIR"
        return 0
    fi

    if ! tmux has-session -t="$selected_name" 2> /dev/null; then
        tmux new-session -ds "$selected_name" -c "$DIR"
    fi

    if [[ -z $TMUX ]]; then
        # We are not in tmux, attach to the existing session
        tmux attach -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
}

if command -v tmux &> /dev/null; then
    tmux_repos "$1"
else
    fd_repos "$1"
fi
