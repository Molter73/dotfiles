#!/usr/bin/env bash

set -euox pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" > /dev/null 2>&1
    pwd -P
)"

BIN_DIR="${XDG_BIN_HOME:-${HOME}/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}"
NVIM_QUERIES="${DATA_DIR}/nvim/site/queries/"

mkdir -p "${BIN_DIR}"

if [[ ! -e "${BIN_DIR}/containerized-ls" ]]; then
    ln -s "${SCRIPTPATH}/containerized-ls.sh" "${BIN_DIR}/containerized-ls"
fi

if [[ ! -e "${BIN_DIR}/kw" ]]; then
    ln -s "${SCRIPTPATH}/kind-wrapper.sh" "${BIN_DIR}/kw"
fi

if [[ ! -e "${BIN_DIR}/regctl" ]]; then
    ln -s "${SCRIPTPATH}/regctl.sh" "${BIN_DIR}/regctl"
fi

if [[ ! -e "${BIN_DIR}/tmux_repos" ]]; then
    ln -s "${SCRIPTPATH}/tmux_repos.sh" "${BIN_DIR}/tmux_repos"
fi

if [[ ! -e "${BIN_DIR}/redeploy" ]]; then
    ln -s "${SCRIPTPATH}/collector-redeploy.sh" "${BIN_DIR}/redeploy"
fi

# Install NeoVim treesitter queries for c3
if [[ ! -e "${NVIM_QUERIES}/c3/highlight.scm" ]]; then
    mkdir -p "${NVIM_QUERIES}/c3/"
    wget -O "${NVIM_QUERIES}/c3/highlights.scm" \
        https://raw.githubusercontent.com/c3lang/tree-sitter-c3/refs/heads/main/queries/highlights.scm
fi
