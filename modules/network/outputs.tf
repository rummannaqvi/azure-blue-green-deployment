output "rg_name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}
output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

output "lb_probe_id" {
  value = azurerm_lb_probe.http.id
}