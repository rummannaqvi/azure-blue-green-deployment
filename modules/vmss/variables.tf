variable "rg_name" {}
variable "location" {}
variable "admin_username" {}
variable "instance_count" {}
variable "min_instances" {}
variable "max_instances" {}
variable "prefix" {}
variable "color" {}

variable "health_probe_id" {}
variable "container_image" {}
variable "subnet_id" {}

variable "vm_size" { default = "Standard_B2s" }
variable "image_publisher" { default = "Canonical" }
variable "image_offer" { default = "0001-com-ubuntu-server-jammy" }
variable "image_sku" { default = "22_04-lts" }
variable "image_version" { default = "latest" }
variable "ni_name" { default = "nic-ipconfig" }

variable "appgw_id" {
  type = string
  default = ""
}

variable "backend_pool_id" {
  type = string
  default = ""
}

variable "ssh_public_key" {
}
variable "lb_backend_pool_id" {}
variable "lb_probe_id" {}