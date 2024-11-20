#!/usr/bin/env bash

set -eoxu pipefail

COLLECTOR_PATH="${GOPATH}/src/github.com/stackrox/collector"
pushd "${COLLECTOR_PATH}"

function create_patch() {
    cat << EOF | jq --arg image "$COLLECTOR_IMAGE" '.spec.template.spec.containers.[0].image |= $image'
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

COLLECTOR_TAG="$(make tag)"
COLLECTOR_IMAGE="quay.io/stackrox-io/collector:${COLLECTOR_TAG}"
PATCH="$(create_patch)"

make image
kind load docker-image "${COLLECTOR_IMAGE}"
kubectl -n stackrox patch ds collector -p "${PATCH}"
kubectl -n stackrox delete pod -l app=collector

popd
