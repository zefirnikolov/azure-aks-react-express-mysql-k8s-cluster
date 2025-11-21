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



provider "kubernetes" {
  host                   = yamldecode(module.aks.kube_config)["clusters"][0]["cluster"]["server"]
  client_certificate     = base64decode(yamldecode(module.aks.kube_config)["users"][0]["user"]["client-certificate-data"])
  client_key             = base64decode(yamldecode(module.aks.kube_config)["users"][0]["user"]["client-key-data"])
  cluster_ca_certificate = base64decode(yamldecode(module.aks.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])
}

provider "helm" {
  kubernetes = {
    host                   = yamldecode(module.aks.kube_config)["clusters"][0]["cluster"]["server"]
    client_certificate     = base64decode(yamldecode(module.aks.kube_config)["users"][0]["user"]["client-certificate-data"])
    client_key             = base64decode(yamldecode(module.aks.kube_config)["users"][0]["user"]["client-key-data"])
    cluster_ca_certificate = base64decode(yamldecode(module.aks.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])
  }
}
