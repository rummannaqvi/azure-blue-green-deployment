resource "azurerm_public_ip" "this" {
  name                = "${var.prefix}-agw-pip"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "this" {
  name                = "${var.prefix}-appgw"
  resource_group_name = var.rg_name
  location            = var.location
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "publicIP"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  ssl_certificate {
    name     = "tlscert"
    key_vault_secret_id = var.key_vault_cert_secret_id
  }

  http_listener {
    name                           = "httpsListener"
    frontend_ip_configuration_name = "publicIP"
    frontend_port_name             = "httpsPort"
    protocol                       = "Https"
    ssl_certificate_name           = "tlscert"
  }

  probe {
    name                = "app-probe"
    protocol            = "Http"
    host                = var.probe_host
    path                = "/health"
    interval            = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
    timeout = 10
  }

  backend_address_pool {
    name = "pool-blue"
  }

  backend_http_settings {
    name                  = "be-http"
    port                  = 80
    protocol              = "Http"
    probe_name            = "app-probe"
    pick_host_name_from_backend_address = true
    cookie_based_affinity = "Disabled"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpsListener"
    backend_address_pool_name  = "pool-blue"
    backend_http_settings_name = "be-http"
  }
}
