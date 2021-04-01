#!/bin/ash
set -e

if [ -z "${GIT_URL}" ]; then
  echo "No repository provided with GIT_URL env var, exiting..."
  exit 1
fi

if [ -z "${GIT_USERNAME}" ]; then
  git config --global user.name "${GIT_USERNAME}"
fi

if [ -z "${GIT_MAIL}" ]; then
  git config --global user.mail "${GIT_MAIL}"
fi

git clone "${GIT_URL}"

gollum --h1-title --emoji /wiki