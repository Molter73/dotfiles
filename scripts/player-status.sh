#!/usr/bin/env bash

set -euo pipefail

title="$(playerctl metadata --format '{{ title }}')"
status="$(playerctl status --format '{{ lc(status) }}')"

st=100
if [[ "$status" == "playing" ]]; then
    st=0
fi

jq -cMn \
    --arg status $st \
    --arg text "$title" \
    '{"text": $text, "percentage": $status | tonumber }'
