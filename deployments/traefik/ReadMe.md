# Traefik

## Authentication
To create the middleware for basic-auth, a secret with basic auth is required.  
To generate;  
```bash
$ kubectl create secret generic basic-auth --from-literal=users=$(htpasswd -nb username password | base64)
```