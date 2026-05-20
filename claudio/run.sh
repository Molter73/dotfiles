#!/usr/bin/env bash
set -euo pipefail

SYSTEM_PROMPT=$(
                cat << 'EOF'
You are running inside a container, you only have access to your current
working directory and your user level configuration. Do not attempt to
perform system wide operations.
EOF
)

base_name="claudio-$(basename "$(pwd)")"
counter=1
container_name="$base_name"

while podman container exists "$container_name" 2> /dev/null; do
    container_name="$base_name-$counter"
    ((counter++))
done

podman run --rm -it \
    --name "$container_name" \
    --userns=keep-id \
    --user "$(id -u):$(id -g)" \
    -e HOME="$HOME" \
    -e CLAUDE_CODE_USE_VERTEX \
    -e CLOUD_ML_REGION \
    -e ANTHROPIC_VERTEX_PROJECT_ID \
    -e PATH \
    -e DBUS_SESSION_BUS_ADDRESS \
    -e XDG_RUNTIME_DIR \
    -v "$(pwd):$(pwd):z" \
    -w "$(pwd)" \
    --security-opt label=disable \
    -v "$HOME/.claude:$HOME/.claude" \
    -v "$HOME/.claude.json:$HOME/.claude.json" \
    -v "$HOME/.config:$HOME/.config" \
    -v "$HOME/.local:$HOME/.local" \
    -v "${XDG_RUNTIME_DIR}/bus:${XDG_RUNTIME_DIR}/bus" \
    quay.io/mmoltras/devcontainers:claudio \
        --append-system-prompt "$SYSTEM_PROMPT" \
        --allowedTools Edit \
        "$@"
