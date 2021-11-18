#!/bin/ash
set -x
missing_config='false'
if [[ -z "${REGISTRY}" ]]; then
  echo 'REGISTRY env variable not set'
  missing_config='true'
fi
if [[ -z "${USERNAME}" ]]; then
  echo 'USERNAME env variable not set'
  missing_config='true'
fi
if [[ -z "${PASSWORD}" ]]; then
  echo 'PASSWORD env variable not set'
  missing_config='true'
fi

if [[ "${missing_config}" == 'true' ]]; then
  echo 'missing config, exiting...'
  exit 1
else
  echo 'no missing config, starting...'
fi

reg server --registry "${REGISTRY}" --username "${USERNAME}" --password "${PASSWORD}"