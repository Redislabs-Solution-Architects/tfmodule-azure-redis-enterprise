/*
This set of Terraform scripts should be turned into a module,
but for now it's a great starting point for Redis Enterprise.
*/
provider "azurerm" {
  version = ">=1.38.0"  
  subscription_id = "beecf88d-33e8-4622-b73a-a7fc84b209c7"  
  client_id       = "868a19e7-cf11-453d-bb7a-9165bc6af1bd"
  client_secret   = var.client_secret
  tenant_id       = "d08e5403-b1c9-4dbf-af91-bab966a84dea"
  features {}
}

provider "azurerm" {
  alias = "azurerm_vs"
  version = ">=1.38.0"  
  subscription_id = "98decbff-8837-4aba-9a3e-d9ea072f555a"
  client_id       = "868a19e7-cf11-453d-bb7a-9165bc6af1bd"
  client_secret   = var.client_secret
  tenant_id       = "d08e5403-b1c9-4dbf-af91-bab966a84dea"  
  features {}
}

terraform {
  backend "azurerm" {}
}