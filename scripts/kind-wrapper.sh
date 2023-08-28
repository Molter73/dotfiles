#!/usr/bin/env bash

set -euo pipefail

CONTROL_SOCKET="${HOME}/.config/kind/kind.sock"

function get_cluster_port() {
	podman inspect --format='{{(index (index .NetworkSettings.Ports "6443/tcp") 0).HostPort}}' molter-control-plane
}

function cluster_exists() {
	clusters="$(kind get clusters)"

	echo "$clusters" | grep -q "molter-control-plane"
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

function create_cluster() {
	clusters="$(kind get clusters)"

	if cluster_exists; then
		echo >&2 "Cluster already exists"
		exit 1
	fi

	kind create cluster --name molter

	# Setup ssh tunneling for accessing the cluster from localhost
	cluster_port="$(get_cluster_port)"
	ssh -fNTMS "${CONTROL_SOCKET}" -L "$cluster_port:127.0.0.1:$cluster_port" remote

	add_metrics_server

	# Deploy the k8s dashboard
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

	create_service_account

	echo "KinD cluster created and ready to go!"
	echo "Running 'kubectl proxy' will expose the dashboard at:"
	echo "	http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
}

function delete_cluster() {
	if ! cluster_exists; then
		echo "Cluster is not created, nothing to be done"
		exit
	fi

	kind delete cluster --name molter

	ssh -S "${CONTROL_SOCKET}" -O exit remote
}

function cluster_status() {
	if cluster_exists; then
		echo "Cluster is already created"
	else
		echo "Cluster is not created"
	fi
}

function get_token() {
	kubectl -n kubernetes-dashboard create token admin-user
}

METHOD="${1:-}"

case "${METHOD}" in
"create")
	create_cluster
	;;
"delete")
	delete_cluster
	;;
"status")
	cluster_status
	;;
"get_token")
	get_token
	;;
*)
	echo >&2 "Unknow option '${METHOD}'"
	exit 1
	;;
esac
