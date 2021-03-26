#!/bin/ash
set -e

if [ -z "${GIT_URL}" ]; then
  echo "No repository provided with GIT_URL env var, exiting..."
  exit 1
fi

git clone "${GIT_URL}"

gollum --h1-title --emoji /wiki