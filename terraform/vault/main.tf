provider "vault" {
  address = var.vault_url
}

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0.0"
    }
  }

  backend "kubernetes" {
    namespace        = "vault"
    secret_suffix    = "vault"
    load_config_file = true
  }

  required_version = ">= 1.0.0"
}

data "vault_policy_document" "admin" {
  rule {
    path         = "sys/health"
    capabilities = ["read", "sudo"]
    description  = "Read system health check"
  }
  rule {
    path         = "sys/policies/acl"
    capabilities = ["list"]
    description  = "List existing policies"
  }
  rule {
    path         = "sys/policies/acl/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Create and manage ACL policies"
  }
  rule {
    path         = "auth/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Manage auth methods broadly across Vault"
  }
  rule {
    path         = "sys/auth/*"
    capabilities = ["create", "update", "delete", "sudo"]
    description  = "Create, update, and delete auth methods"
  }
  rule {
    path         = "sys/auth"
    capabilities = ["read"]
    description  = "List auth methods"
  }
  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "List, create, update, and delete key/value secrets"
  }

  rule {
    path         = "sys/mounts/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Manage secret engines"
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
    description  = "List existing secrets engines."
  }
  rule {
    path         = "personal-accounts/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description = "Handle all personal accounts secrets"
  }
  rule {
    path         = "recovery/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description = "Handle all recovery secrets"
  }
  rule {
    path         = "web-services/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description = "Handle all web-services secrets"
  }
}

# Adding Admin policy and user
resource "vault_policy" "admin-policy" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
  tune {
    default_lease_ttl = "1h"
    max_lease_ttl     = "2h"
  }
}

# Adding Kubernetes auth method
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

data "vault_policy_document" "web-services" {
  rule {
    path         = "web-services/*"
    capabilities = ["list", "read"]
    description  = "List and get from web-services secret backend"
  }
}

resource "vault_policy" "web-services" {
  name   = "web-services"
  policy = data.vault_policy_document.web-services.hcl
}

resource "vault_kubernetes_auth_backend_role" "services_vault-access" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "web-services"
  bound_service_account_names      = ["vault-access"]
  bound_service_account_namespaces = ["services"]
  token_ttl                        = 3600
  token_max_ttl                    = 18000
  token_policies                   = ["web-services"]
}