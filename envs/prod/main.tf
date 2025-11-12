terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


module "network" {
  source = "../../modules/network"
  resource_group_name = "prod-rg"
  location = "East US"
  prefix = "ent-prod"
}

module "key_vault" {
  source = "../../modules/key_vault"
  prefix = "ent-prod"
  location = module.network.location
  rg_name = module.network.rg_name
  allowed_subnet_ids = [
    module.network.appgw_subnet_id,
    module.network.app_subnet_id
  ]
}


module "appgw" {
  source = "../../modules/app_gateway"

  prefix           = "ent-prod"
  rg_name          = module.network.rg_name
  location         = module.network.location
  appgw_subnet_id  = module.network.appgw_subnet_id
  key_vault_cert_secret_id = module.key_vault.cert_secret_id

  probe_host = "localhost"
}


module "vmss_blue" {
  source = "../../modules/vmss"

  prefix       = "ent-prod"
  color        = "blue"
  rg_name      = module.network.rg_name
  location     = module.network.location
  subnet_id    = module.network.app_subnet_id

  vm_size       = "Standard_B2s"
  admin_username = "rumman"

  container_image = "myacr.azurecr.io/myapp:latest"

  instance_count = 2
  min_instances  = 1
  max_instances  = 5

  health_probe_id = module.appgw.probe_id

  appgw_id = module.appgw.id
  backend_pool_id = module.appgw.blue_pool_id


  lb_probe_id = module.network.lb_probe_id
  lb_backend_pool_id = module.network.lb_backend_pool_id
  ssh_public_key = ""
}

module "vmss_green" {
  source = "../../modules/vmss"

  prefix       = "ent-prod"
  color        = "green"
  rg_name      = module.network.rg_name
  location     = module.network.location
  subnet_id    = module.network.app_subnet_id

  vm_size       = "Standard_B2s"
  admin_username = "rumman"

  container_image = "myacr.azurecr.io/myapp:latest"

  instance_count = 0
  min_instances  = 0
  max_instances  = 5

  health_probe_id = module.appgw.probe_id

  appgw_id = module.appgw.id
  backend_pool_id = module.appgw.blue_pool_id

  lb_probe_id = module.network.lb_probe_id
  lb_backend_pool_id = module.network.lb_backend_pool_id
  ssh_public_key = ""
}