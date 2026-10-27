#!/usr/bin/env bash

set -euo pipefail

PROFILE="${OPENCODE_SANDBOX_PROFILE:-opencode-personal}"

BW_STATUS="$(bw status | jq .status)"
if [[ "${BW_STATUS}" != "unlocked" ]]; then
    echo "Unlocking Bitwarden"
    export BW_SESSION
    BW_SESSION="$(bw unlock --raw)"
fi

exec nono run \
    --profile "$PROFILE" \
    --log-file "${XDG_STATE_HOME:-${HOME}/.local/state}/nono/opencode-sandboxed.log" \
    --allow-cwd -- \
        opencode --auto
