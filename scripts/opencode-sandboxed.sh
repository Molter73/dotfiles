#!/usr/bin/env bash

set -euo pipefail

PROFILE="${OPENCODE_SANDBOX_PROFILE:-opencode-vertex}"
LOW=32768
HIGH=60999

pick_port() {
    local port
    for _ in $(seq 1 20); do
        port=$(( RANDOM % (HIGH - LOW + 1) + LOW ))
        if ! ss -ltn "sport = :${port}" 2>/dev/null | grep -q LISTEN; then
            printf '%s\n' "$port"
            return 0
        fi
    done
    echo "opencode-sandboxed: could not find a free port in ${LOW}-${HIGH}" >&2
    return 1
}

# Runs inside the sandbox, started by the re-exec at the bottom of this file.
attach() {
    local port="$1"

    opencode serve --hostname 127.0.0.1 --port "$port" >"/dev/null" 2>&1 &
    local server_pid=$!
    trap 'kill "$server_pid" 2>/dev/null' EXIT

    for _ in $(seq 1 50); do
        curl -fsS -u "opencode:${OPENCODE_SERVER_PASSWORD}" \
            "http://127.0.0.1:${port}/api/info" >/dev/null 2>&1 && break
        sleep 0.1
    done

    exec opencode --server "http://127.0.0.1:${port}" --auto
}

if [[ "${1:-}" == "--attach" ]]; then
    attach "$2"
    exit
fi

PORT="$(pick_port)"
export OPENCODE_SERVER_PASSWORD
OPENCODE_SERVER_PASSWORD="$(head -c32 /dev/urandom | base64)"

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
        opencode-sandboxed --attach "$PORT"
