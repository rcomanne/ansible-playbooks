#!/bin/bash
set -e

echo "Copying current config"
tmp_dir=$(mktemp -d)
tmp_config="${tmp_dir}/config"
cd "${tmp_dir}"
cp ~/.kube/config "${tmp_config}"

echo "Removing current context and credentials"
kubectl --kubeconfig="${tmp_config}" config delete-user kubernetes-admin
kubectl --kubeconfig="${tmp_config}" config delete-context kubernetes-admin@kubernetes


echo "=================================================="
echo "+ Injecting new context and credentials   ...    +"
echo "=================================================="

echo "Injecting new context and credentials"
sa_user="jenkins-sa-user"
kubectl --kubeconfig="${tmp_config}" config set-context jenkins-sa --cluster=kubernetes --user="${sa_user}"
kubectl --kubeconfig="${tmp_config}" config use-context jenkins-sa
kubectl --kubeconfig="${tmp_config}" config set-credentials jenkins-sa-user \
  --token $(kubectl get secrets -o json | jq -r '.items[] | select(.metadata.name | test("jenkins-token-")).data.token' | base64 -d)

echo "=================================================="
echo "+ Injecting new context and credentials   DONE!  +"
echo "=================================================="
cat "${tmp_config}"