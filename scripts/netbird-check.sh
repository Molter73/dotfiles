#!/usr/bin/env bash

set -euo pipefail

st="$(netbird status --json)"
management="$(echo "$st" | jq '.management.connected')"
signal="$(echo "$st" | jq '.signal.connected')"

if [[ "$management" == "true" && "$signal" == "true" ]]; then
    class="up"
elif [[ "$management" == "false" && "$signal" == "false" ]]; then
    class="down"
else
    class="error"
fi

jq -cMn \
    --arg class $class \
    '{"class": $class}'
