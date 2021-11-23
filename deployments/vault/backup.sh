#!/bin/bash

VAULT_FORMAT=json

engines=("recovery" "personal-accounts" "web-services")

for engine in "${engines[@]}"; do
  echo "Engine: ${engine}"
  vault kv list "${engine}" > "${engine}.json"
  for secret in $(jq -rc '.[]' "${engine}.json"); do
    echo "Secret: ${secret}"
    vault kv get "${engine}/${secret}" | jq '.data.data' > "${engine}_${secret}.json"
  done
done
