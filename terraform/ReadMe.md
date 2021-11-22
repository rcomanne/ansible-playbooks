# Terraform
This terraform directory contains some resources that we need configured, that cannot easily be managed otherwise.  

## Subdirectories
We have the following subdirectories that each manage a piece of infrastructure;  
- recovery  
This contains a KeyVault that can be used to store the initial HashiCorp Vault recovery keys in, so we always have them available when needed.  
- vault  
This contains the configuration of HashiCorp Vault itself.  

## How to run
### Requirements
Terraform is configured to use k8s as a storage backend. Doing so, it will create a secret for every state file that it creates with the suffix provided.  
This means that we need to be connected to a k8s cluster in order to use them.  

We also expect to be connected to Azure to one way or another, the easiest way is to log in through the Azure CLI;  
```bash
$ az login
```

### Run
In order to apply a desired state;
1. Go to the subdirectory desired
    ```bash
    $ cd recovery  
    ```
2. Run init to configure and setup terraform
    ```bash
    $ terraform init  
    ```
3. Run plan to view possible changes
    ```bash
    $ terraform plam  
    ```
4. Run apply to apply any changes
    ```bash
    $ terraform apply  
    ```