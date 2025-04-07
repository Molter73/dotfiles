#!/usr/bin/env bash

set -eoxu pipefail

HOTRELOAD=${HOTRELOAD:-false}
COLLECTOR_PATH="${GOPATH}/src/github.com/stackrox/collector"
pushd "${COLLECTOR_PATH}"

function patch_image() {
    cat << EOF | jq \
        --arg image "$COLLECTOR_IMAGE" \
        '.spec.template.spec.containers.[0].image |= $image'
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "collector",
            "image": "\$image",
            "imagePullPolicy": "IfNotPresent"
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
            "command": ["/host/src/cmake-build/collector/collector"],
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

COLLECTOR_TAG="$(make tag)"
COLLECTOR_IMAGE="quay.io/stackrox-io/collector:${COLLECTOR_TAG}"

make image-dev
kind load docker-image "${COLLECTOR_IMAGE}"
kubectl -n stackrox patch ds collector -p "$(patch_image)"
if [[ "${HOTRELOAD}" == "true" ]]; then
    kubectl -n stackrox patch ds collector -p "$(patch_hotreload)"
fi
kubectl -n stackrox delete pod -l app=collector

popd
