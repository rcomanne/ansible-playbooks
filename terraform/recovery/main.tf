provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.85"
    }
  }

  backend "kubernetes" {
    namespace        = "vault"
    secret_suffix    = "recovery"
    load_config_file = true
  }

  required_version = ">= 1.0.0"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_key_vault" "vault-seal-keys" {
  name                       = "hc-vault-seal-keys"
  location                   = var.location
  resource_group_name        = var.resource_group
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
  }

  depends_on = [azurerm_resource_group.rg]
}