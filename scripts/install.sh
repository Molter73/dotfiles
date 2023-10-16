#!/usr/bin/env bash

set -euox pipefail

SCRIPTPATH="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
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

if [[ ! -e "${BIN_DIR}/repos" ]]; then
    ln -s "${SCRIPTPATH}/repos.sh" "${BIN_DIR}/repos"
fi
