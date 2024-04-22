#!/usr/bin/env bash

set -euo pipefail

source "${GOPATH}/src/github.com/molter73/dotfiles/scripts/container-registry.sh"

CONTROL_SOCKET="${HOME}/.config/kind/kind.sock"

function usage() {
    echo "$0 <METHOD> <CLUSTER>"
    echo ""
    echo "METHOD - One of the following:"
    echo "  create	Create a kind cluster"
    echo "  delete	Delete a kind cluster"
    echo "  status	Check if the cluster has already been created"
    echo "  get_token	Get a token for authenticating to the k8s dashboard"
    echo ""
    echo "CLUSTER - The name of the cluster to interact with (default: kind)"
}

function get_cluster_port() {
    podman inspect --format='{{(index (index .NetworkSettings.Ports "6443/tcp") 0).HostPort}}' "$1-control-plane"
}

function cluster_exists() {
    cluster_name="$1"
    clusters="$(kind get clusters)"

    echo "$clusters" | grep -q "${cluster_name}"
}

function create_service_account() {
    # Extracted from:
    #   https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
    cat << 'EOF' | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

    cat << 'EOF' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
}

function add_metrics_server() {
    # Extracted from:
    #   - https://gist.github.com/sanketsudake/a089e691286bf2189bfedf295222bd43
    #   - https://gist.github.com/sanketsudake/a089e691286bf2189bfedf295222bd43?permalink_comment_id=3914458#gistcomment-3914458
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
    kubectl patch -n kube-system deployment metrics-server --type=json \
        -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
}

function setup_ingress() {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

    echo "Waiting for ingress controller to start up"
    sleep 15

    # Wait for ingress to become available
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=300s
}

function add_local_registry() {
    if ! registry_exists "${REGISTRY_NAME}"; then
        return
    fi

    REGISTRY_DIR="/etc/containerd/certs.d/localhost:${REGISTRY_PORT}"
    for node in $(kind get nodes); do
        podman exec "${node}" mkdir -p "${REGISTRY_DIR}"
        cat << EOF | podman exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${REGISTRY_NAME}:5000"]
EOF
    done

    # Connect the registry to the cluster network if not already connected
    # This allows kind to bootstrap the network but ensures they're on the same network
    if [ "$(podman inspect -f='{{json .NetworkSettings.Networks.kind}}' "${REGISTRY_NAME}")" = 'null' ]; then
        podman network connect "kind" "${REGISTRY_NAME}"
    fi

    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
    name: local-registry-hosting
    namespace: kube-public
data:
    localRegistryHosting.v1: |
        host: "localhost:${REGISTRY_PORT}"
        help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
}

function create_cluster() {
    cluster_name="$1"
    clusters="$(kind get clusters)"

    if cluster_exists "${cluster_name}"; then
        echo >&2 "Cluster already exists"
        exit 1
    fi

    cat << EOF | kind create cluster --name "${cluster_name}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 5000
    protocol: TCP
  - containerPort: 443
    hostPort: 5443
    protocol: TCP
  extraMounts:
  - hostPath: "${HOME}/go/src"
    containerPath: "${HOME}/go/src"
EOF

    add_local_registry
    add_metrics_server

    # Deploy the k8s dashboard
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

    create_service_account

    setup_ingress

    echo "KinD cluster created and ready to go!"
    echo "Running 'kubectl proxy' will expose the dashboard at:"
    echo "	http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
}

function delete_cluster() {
    cluster_name="$1"
    if ! cluster_exists "${cluster_name}"; then
        echo "Cluster is not created, nothing to be done"
        exit
    fi

    kind delete cluster --name "${cluster_name}"
}

function cluster_status() {
    if cluster_exists "$1"; then
        echo "Cluster is already created"
    else
        echo "Cluster is not created"
    fi
}

function get_token() {
    kubectl -n kubernetes-dashboard create token admin-user
}

if (($# == 0)); then
    echo >&2 "At least one parameter must be supplied"
    usage
    exit 1
fi

METHOD="${1:-}"
shift
CLUSTER_NAME="${1:-kind}"

case "${METHOD}" in
    "create")
        create_cluster "$CLUSTER_NAME"
        ;;
    "delete")
        delete_cluster "${CLUSTER_NAME}"
        ;;
    "status")
        cluster_status "${CLUSTER_NAME}"
        ;;
    "get_token")
        get_token
        ;;
    "-h" | "--help")
        usage
        exit 0
        ;;
    *)
        echo >&2 "Unknow option '${METHOD}'"
        exit 1
        ;;
esac
