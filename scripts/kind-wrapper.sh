#!/usr/bin/env bash

set -euo pipefail

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
	cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

	cat <<'EOF' | kubectl apply -f -
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
	sleep 1

	echo "Waiting for ingress controller to start up"
	# Wait for ingress to become available
	kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=300s
}

function create_cluster() {
	cluster_name="$1"
	clusters="$(kind get clusters)"

	if cluster_exists "${cluster_name}"; then
		echo >&2 "Cluster already exists"
		exit 1
	fi

	cat <<EOF | kind create cluster --name "${cluster_name}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
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
EOF

	# Setup ssh tunneling for accessing the cluster from localhost
	cluster_port="$(get_cluster_port "${cluster_name}")"
	ssh -fNTMS "${CONTROL_SOCKET}" -L "$cluster_port:127.0.0.1:$cluster_port" remote

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

	ssh -S "${CONTROL_SOCKET}" -O exit remote
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
