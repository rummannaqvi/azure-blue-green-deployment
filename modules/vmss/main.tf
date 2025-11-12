resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "${var.prefix}-${var.color}-vmss"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.vm_size
  admin_username      = var.admin_username
  instances           = var.instance_count

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  health_probe_id = var.health_probe_id

  custom_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {
    container_image = var.container_image
  }))

  upgrade_mode = "Automatic"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id

      application_gateway_backend_address_pool_ids = [
        var.backend_pool_id
      ]
    }
  }
}
/*

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "${var.prefix}-vmss"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.vm_size
  instances           = var.instance_count
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool_id]
    }
  }

  health_probe_id = var.lb_probe_id
}*/

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "${var.prefix}-${var.color}-autoscale"
  resource_group_name = var.rg_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.this.id

  profile {
    name = "autoscale-profile"

    capacity {
      default = var.instance_count
      minimum = var.min_instances
      maximum = var.max_instances
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}