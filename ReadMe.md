# Single node Kubernetes cluster
This repository is used by me to set up and configure a single node k8s cluster.

# Run
## Initial
The intial run creates a remote user, sets up SSH and disables root and password login
```bash
$ mkpasswd --method=sha-512
$ ansible-playbook --ask-pass -e password=GENERATED_HASH initial.yml
```

## Base
Base installs some common packages and configurations, using the newly generated user.
```bash
$ ansible-playbook --ask-become-pass base.yml
```