terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateacct1234"        
    container_name       = "tfstate"
    key                  = "enterprise-platform-prod.tfstate"
  }
}
