#!/usr/bin/env bash

set -euxo pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" > /dev/null 2>&1
    pwd -P
)"
CLAUDE_DIR="${HOME}/.claude"

function create_symlink() {
    local file_name="$1"
    if [[ ! -e "${CLAUDE_DIR}/${file_name}" ]]; then
        ln -s "${SCRIPTPATH}/${file_name}" "${CLAUDE_DIR}/${file_name}"
    fi
}

mkdir -p "${CLAUDE_DIR}"

for f in settings.json CLAUDE.md; do
    create_symlink "$f"
done
