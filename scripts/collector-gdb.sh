#!/usr/bin/env bash

set -emuo pipefail

HOTRELOAD=0
COLLECTOR_PATH="${GOPATH:-}/src/github.com/stackrox/collector"

function usage() {
    cat << EOF
$(basename "$0") [OPTIONS] -- <GDB_ARGUMENTS>

Configure a runnning collector pod for debugging and delegate to gdb.

OPTIONS:
    -h, --help
        Show this help.
    -r, --hotreload
        Mount the collector binary from the host.
    -p, --path
        Path to the collector repository in the host (default: $GOPATH/src/github.com/stackrox/collector)
EOF
}

function die() {
    echo 1>&2 "$1"
    exit 1
}

function check_command() {
    if ! command -v "$1" &> /dev/null; then
        die "$1 not found. Make sure it is in your path"
    fi
}

function krox() {
    kubectl -n stackrox "$@"
}

function patch_gdb() {
    cat << EOF | jq
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "collector",
            "command": ["gdbserver"],
            "args": ["0.0.0.0:1337", "collector"],
            "ports": [{
              "containerPort": 1337,
              "name": "gdb",
              "protocol": "TCP"
            }]
          }
        ]
      }
    }
  }
}
EOF
}

function patch_hotreload() {
    cat << EOF | jq \
        --arg hostPath "$COLLECTOR_PATH" \
        '.spec.template.spec.volumes.[0].hostPath.path |= $hostPath'
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "collector",
            "command": ["gdbserver"],
            "args": ["0.0.0.0:1337", "/host/src/cmake-build/collector/collector"],
            "volumeMounts": [
              {
                "mountPath": "/host/src",
                "name": "collector-src",
                "readOnly": true
              }
            ]
          }
        ],
        "volumes": [
          {
            "hostPath": {
              "path": "\$hostPath",
              "type": ""
            },
            "name": "collector-src"
          }
        ]
      }
    }
  }
}
EOF
}

# TODO: remove the src mounts on hotreload
function patch_restore() {
    cat << EOF | jq
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "collector",
            "command": ["collector"],
            "args": [],
            "ports": []
          }
        ]
      }
    }
  }
}
EOF
}

function restore_exit() {
    krox patch ds collector -p "$(patch_restore)"
}

function handle_exit() {
    restore_exit
    kill "${PORT_FORWARD:-}"
}

check_command jq
check_command kubectl

TEMP=$(getopt -o 'hrp:' -l 'help,hotreload,path:' -n "$0" -- "$@")

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$TEMP"
unset TEMP

while true; do
    case "${1:-}" in
        '-h' | '--help')
            usage
            exit 0
            ;;

        '-r' | '--hotreload')
            HOTRELOAD=1
            shift
            ;;

        '-p' | '--path')
            COLLECTOR_PATH="$2"
            shift 2
            ;;

        '--')
            shift
            break
            ;;

        *)
            break
            ;;
    esac
done

if ! krox get ds/collector &> /dev/null; then
    die "collector daemonset not found (did you forget to deploy stackrox?)"
fi

trap handle_exit EXIT

if ((HOTRELOAD)); then
    krox patch ds collector -p "$(patch_hotreload)"
else
    krox patch ds collector -p "$(patch_gdb)"
fi

krox wait --for=delete -l app=collector --timeout 10s pod || true
krox wait --for=condition=Ready -l app=collector --timeout 60s pod

# We can't use the krox function here because it will result in the
# wrong pid being captured.
kubectl -n stackrox port-forward --pod-running-timeout=1m0s ds/collector 40000:1337 &> /dev/null &
PORT_FORWARD=$!

gdb -ex "target extended-remote localhost:40000" "$@"
