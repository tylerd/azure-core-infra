terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.18.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatee1nod"
    container_name       = "tfstate"
    key                  = "azure-core-infra.tfstate"
  }

}

provider "azurerm" {
  features {}
}
