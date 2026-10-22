#!/usr/bin/env bash

set -exuo pipefail

OPENCODE_SKILLS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/opencode/skills"

function usage() {
    echo 2>& "$0 <SKILLS_DIRECTORY>"
}

function create_symlink() {
    # Extract link_name and target from arguments
    local target="$1"
    local link_name
    link_name="$(basename "$target")"

    if [[ ! -L "${OPENCODE_SKILLS_DIR}/${link_name}" ]]; then
        ln -s "$target" "${OPENCODE_SKILLS_DIR}/$link_name"
    fi
}

if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

for skill in "$1"/*; do
    create_symlink "$skill"
done
