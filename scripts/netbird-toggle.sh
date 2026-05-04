#!/usr/bin/env bash

set -euo pipefail

st="$(netbird status --json)"
management="$(echo "$st" | jq '.management.connected')"
signal="$(echo "$st" | jq '.signal.connected')"

if [[ "$management" == "true" && "$signal" == "true" ]]; then
    if ! netbird down; then
        notify-send "Failed to disconnect NetBird"
    fi
else
    if ! netbird up; then
        notify-send "Failed to connect NetBird"
    fi
fi
