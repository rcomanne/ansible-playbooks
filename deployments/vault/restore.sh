#!/bin/bash

export VAULT_FORMAT='json'

engines=("recovery" "personal-accounts" "web-services")

for engine in "${engines[@]}"; do
  echo "Engine: ${engine}"
  for secret in $(jq -rc '.[]' "${engine}.json"); do
    echo "Secret: ${secret}"
    vault kv put "${engine}/${secret}" @"${engine}_${secret}.json"
  done
done