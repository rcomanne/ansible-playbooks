#!/bin/bash

# Enable audit logging
vault audit enable file file_path=/vault/logs/audit.log

# Enable secret backends
enabled_secrets=$(vault secrets list -format json)
# personal-accounts
if [[ $(echo "${enabled_secrets}" | jq '. | has("personal-accounts/")') == 'true' ]]; then
  echo 'personal-accounts already exists'
else
  vault secrets enable -path=personal-accounts kv-v2
fi
# web-services
if [[ $(echo "${enabled_secrets}" | jq '. | has("web-services/")') == 'true' ]]; then
  echo 'web-services already exists'
else
  vault secrets enable -path=web-services kv-v2
fi
# recovery
if [[ $(echo "${enabled_secrets}" | jq '. | has("recovery/")') == 'true' ]]; then
  echo 'recovery already exists'
else
  vault secrets enable -path=personal-accounts kv-v2
fi

vault read auth/userpass/users/${USER} || {
read -rsp 'Please provide a password: ' password
vault write auth/userpass/users/${USER} \
  password="${password}" \
  policies=admin
}

#echo 'https://www.vaultproject.io/docs/platform/k8s/helm/examples/kubernetes-auth'
#echo 'The easiest way to get this, is to go in to the Vault pod'
#echo 'kubectl exec -it <VAULT_POD> -- /bin/ash'

#echo 'First, the JWT'
#echo 'cat /var/run/secrets/kubernetes.io/serviceaccount/token'
#read -rp 'JWT: ' jwt
#echo 'Then the kubernetes host, internal tcp 443 address'
#echo 'echo ${KUBERNETES_PORT_443_TCP_ADDR}'
#read -rp 'HOST: ' host
#echo 'And last, the CA cert'
#echo 'For this, please create a local file and give the path to file'
#echo 'cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
#read -rp 'CA Path: ' ca_path
#
#vault write auth/kubernetes/config \
#  token_reviewer_jwt="${jwt}" \
#  kubernetes_host="https://${host}:443" \
#  kubernetes_ca_cert=@${ca_path}