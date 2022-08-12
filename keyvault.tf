resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "keyvault_rg" {
  name     = "tyler-cert-kv-rg"
  location = "westus3"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                       = "tyler-cert-kv-${random_string.resource_code.result}"
  location                   = azurerm_resource_group.keyvault_rg.location
  resource_group_name        = azurerm_resource_group.keyvault_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"
}