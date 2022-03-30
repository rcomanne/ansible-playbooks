#!/bin/bash
set -eou pipefail

user=${USER}
group='cluster-admin'

mkdir -p certs
cd certs

if [ -f "${user}.key" ]; then
  echo 'key already exists'
else
  echo 'Generating private key'
  openssl genrsa -out ${user}.key 4096
fi

echo 'Generating CSR config file'
cat << EOF > ${user}-csr.cnf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
CN = ${user}
O = ${group}

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=clientAuth
EOF

echo 'Generating CSR'
openssl req -config ${user}-csr.cnf -new -key ${user}.key -nodes -out ${user}.csr

CSR_BASE64=$(cat ${user}.csr | base64 -w 0)
cat << EOF > ${user}-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${user}
spec:
  groups:
  - system:authenticated
  request: ${CSR_BASE64}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
kubectl apply -f ${user}-csr.yaml

kubectl get csr
kubectl certificate approve ${user}
kubectl get csr
kubectl get csr -o json ${user} | jq -r '.status.certificate' | base64 -d > rcomanne.pem
