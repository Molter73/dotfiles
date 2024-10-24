#!/usr/bin/env bash

set -euox pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" > /dev/null 2>&1
    pwd -P
)"

BIN_DIR="${HOME}/.bin"

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
