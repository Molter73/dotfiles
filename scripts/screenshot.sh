#!/usr/bin/env bash

set -euo pipefail

FILE="${HOME}/Pictures/Screenshots/scrn-$(date +'%Y-%m-%d-%H-%M-%s').png"
OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"

if (($# == 0)); then
    grim -o "${OUTPUT}" - | wl-copy
elif (($# == 1)) && [[ "$1" == "-c" || "$1" == "--clip" ]]; then
    slurp | grim -g - - | wl-copy
else
    echo >&2 "Invalid arguments"
    exit 1
fi

wl-paste > "${FILE}"
notify-send \
    -i "${FILE}" \
    "Screenshot taken" \
    "The image has also been added to your clipboard"
