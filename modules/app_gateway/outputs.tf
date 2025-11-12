output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "probe_id" {
  value = tolist(azurerm_application_gateway.this.probe)[0].id
}

output "id" {
  value = azurerm_application_gateway.this.id
}

output "blue_pool_id" {
  value = tolist(azurerm_application_gateway.this.backend_address_pool)[0].id
}