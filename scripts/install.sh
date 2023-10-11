#!/usr/bin/env bash

set -euox pipefail

SCRIPTPATH="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

BIN_DIR="${HOME}/.bin"

mkdir -p "${BIN_DIR}"

if [[ ! -e "${BIN_DIR}/cclangd" ]]; then
    ln -s "${SCRIPTPATH}/cclangd.sh" "${BIN_DIR}/cclangd"
fi

if [[ ! -e "${BIN_DIR}/kw" ]]; then
    ln -s "${SCRIPTPATH}/kind-wrapper.sh" "${BIN_DIR}/kw"
fi
