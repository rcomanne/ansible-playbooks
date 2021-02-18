#!/bin/bash
set -e

echo "========================================"
echo "+ Building Docker image     ...        +"
echo "========================================"
docker build -t docker.rcomanne.nl/jenkins-agent:1.0 .
echo "========================================"
echo "+ Building Docker image     DONE!      +"
echo "========================================"
echo

echo "========================================"
echo "+ Releasing Docker image    ...        +"
echo "========================================"
docker push docker.rcomanne.nl/jenkins-agent:1.0
echo "========================================"
echo "+ Releasing Docker image    DONE!      +"
echo "========================================"