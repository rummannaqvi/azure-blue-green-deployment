resource "azurerm_postgresql_flexible_server" "db" {
  name                = var.server_name
  resource_group_name = var.rg_name
  location            = var.location
  administrator_login = var.admin_user
  administrator_password = var.admin_password
  sku_name            = "Standard_D2s_v3"
  version             = "14"
  storage_mb          = 32768
  delegated_subnet_id = var.subnet_id
}