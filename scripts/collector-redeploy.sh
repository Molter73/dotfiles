#!/usr/bin/env bash

set -eoxu pipefail

COLLECTOR_PATH="${GOPATH}/src/github.com/stackrox/collector"
pushd "${COLLECTOR_PATH}"

make image
kubectl -n stackrox delete configmaps collector-config || true
kind load docker-image quay.io/stackrox-io/collector:"$(make tag)"
kubectl -n stackrox delete pod -l app=collector

sleep 5
cat << EOF | kubectl -n stackrox apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: collector-config
  namespace: stackrox
data:
  runtime_config.yaml: |
    networking:
        externalIps:
          enable: true
EOF

popd
