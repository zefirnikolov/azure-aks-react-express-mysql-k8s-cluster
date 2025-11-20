terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.52"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
  }
}

provider "azurerm" {
  features {}
}
