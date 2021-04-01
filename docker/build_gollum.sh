#!/bin/bash

date_tag="$(date +%d.%m.%Y)"

docker build \
  --build-arg ssh_key="$(cat ~/.ssh/k8s_id_git)" \
  -t docker.rcomanne.nl/gollum \
  -t docker.rcomanne.nl/gollum:${date_tag} \
  -f gollum/Dockerfile \
  gollum/

docker push docker.rcomanne.nl/gollum
docker push docker.rcomanne.nl/gollum:${date_tag}