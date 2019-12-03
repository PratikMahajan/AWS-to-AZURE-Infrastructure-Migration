data "azurerm_image" "centos" {
  name                = "${var.centos_image_name}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb" "vm_lb" {
  name                = "az_loadbal"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PubIPAddr"
    public_ip_address_id = "${var.public_ip_address_id}"
  }
}

resource "azurerm_lb_backend_address_pool" "be_addr_pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = "${azurerm_lb.vm_lb.id}"
  name                = "BackendAddrpool"
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = "${azurerm_lb.vm_lb.id}"
  name                = "http_probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}

resource "azurerm_lb_nat_pool" "lb_nat_pool" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = "${azurerm_lb.vm_lb.id}"
  name                           = "app_pool"
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 81
  backend_port                   = 8080
  frontend_ip_configuration_name = "PubIPAddr"
}

resource "azurerm_virtual_machine_scale_set" "vm_scale" {
  name                  = "VM_CSYE6225"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  health_probe_id = "${azurerm_lb_probe.lb_probe.id}"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }
  
  storage_profile_image_reference {
    id = data.azurerm_image.centos.id
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name_prefix  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password12345"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  network_profile {
    name    = "nwprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfig"
      primary                                = true
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.be_addr_pool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${azurerm_lb_nat_pool.lb_nat_pool.id}"]
    }
  }

}

