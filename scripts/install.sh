#!/usr/bin/env bash

set -euox pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" > /dev/null 2>&1
    pwd -P
)"

BIN_DIR="${XDG_BIN_HOME:-${HOME}/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}"
NVIM_QUERIES="${DATA_DIR}/nvim/site/queries/"

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

# Install NeoVim treesitter queries for c3
if [[ ! -e "${NVIM_QUERIES}/c3/highlight.scm" ]]; then
    mkdir -p "${NVIM_QUERIES}/c3/"
    wget -O "${NVIM_QUERIES}/c3/highlights.scm" \
        https://raw.githubusercontent.com/c3lang/tree-sitter-c3/refs/heads/main/queries/highlights.scm
fi
