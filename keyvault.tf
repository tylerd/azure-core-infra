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

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "DeleteIssuers",
      "GetIssuers",
      "ListIssuers",
      "ManageIssuers",
      "SetIssuers",
    ]
  }
}

resource "azurerm_key_vault_certificate_issuer" "digicert_issuer" {
  name          = "digicert-issuer"
  org_id        = var.digicert_org_id
  key_vault_id  = azurerm_key_vault.keyvault.id
  provider_name = "DigiCert"
  account_id    = var.digicert_account_id
  password      = var.digicert_api_key
}