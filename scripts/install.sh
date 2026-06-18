#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" > /dev/null 2>&1
    pwd -P
)"

BIN_DIR="${XDG_BIN_HOME:-${HOME}/.local/bin}"

function create_symlink() {
    # Extract link_name and target from arguments
    local target="$1"
    local link_name="${2:-}"

    if [[ -z "$link_name" ]]; then
        link_name="${target%.sh}"
    fi

    if [[ ! -e "${BIN_DIR}/${link_name}" ]]; then
        ln -s "${SCRIPTPATH}/$target" "${BIN_DIR}/$link_name"
    fi
}

mkdir -p "${BIN_DIR}"

create_symlink containerized-ls.sh
create_symlink kind-wrapper.sh kw
create_symlink regctl.sh
create_symlink tmux_repos.sh
create_symlink tmux-popup.sh
create_symlink tmux-sessions.sh
create_symlink collector-redeploy.sh redeploy
create_symlink collector-gdb.sh cgdb
create_symlink watch-run.sh wrun
create_symlink screenshot.sh
create_symlink dnf-check-update.sh
create_symlink player-status.sh
create_symlink netbird-check.sh
create_symlink netbird-toggle.sh
