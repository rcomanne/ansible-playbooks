# Single node Kubernetes cluster
This repository is used by me to set up and configure a single node k8s cluster with some deployments.

## Run

### Deployments

#### docker-registry
Before you apply the files in the docker-registry dir, an extra file needs to be created containing basic auth setup.  
You can generate basic auth sets with `htpasswd` and then you can put each of them on a line in the config map.
```bash
kind: ConfigMap
apiVersion: v1
metadata:
  name: docker-registry-basic-auth
  namespace: docker
data:
  htpasswd: |
    user:pass
```

To create an image pull secret, use your newly created credentials to create a secret  
```bash
kubectl create secret docker-registry private-registry \
  --docker-username=${docker_username} \
  --docker-password=${docker_password}
```