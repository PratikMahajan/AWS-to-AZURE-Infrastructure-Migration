resource "azurerm_lb" "lb" {
  resource_group_name = var.resource_group_name
  name                = "${var.env}lb"
  location            = var.location

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = var.azure_public_ip
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.env}-BackendPool"
}

//resource "azurerm_lb_probe" "lb_probe" {
//  resource_group_name = var.resource_group_name
//  loadbalancer_id     = azurerm_lb.lb.id
//  name                = "httpProbe"
//  protocol            = "http"
//  port                = 80
//  request_path        = "/health"
//  interval_in_seconds = 5
//  number_of_probes    = 2
//}

resource "azurerm_lb_probe" "ssh" {
  name                = "ssh-running-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  port                = 22
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.ssh.id
  depends_on                     = ["azurerm_lb_probe.ssh"]
}


data "azurerm_image" "search" {
  resource_group_name = var.resource_group_name
  name = var.image_name
}

resource "azurerm_virtual_machine_scale_set" "vm" {
  name                  = "${var.env}vm"
  location              = var.location
  resource_group_name   = var.resource_group_name

  overprovision        = true
  upgrade_policy_mode  = "Rolling"
  automatic_os_upgrade = false
  health_probe_id      = azurerm_lb_probe.ssh.id


  storage_profile_image_reference {
    id = data.azurerm_image.search.id
  }

  os_profile {
    admin_username = var.admin_username
    computer_name_prefix = "${var.env}-vm"
  }

  os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/centos/.ssh/authorized_keys"
            key_data = var.ssh_key_data
        }
    }

  network_profile {
    name = "${var.env}networkprofile"
    primary = true
    ip_configuration {
      name = "${var.env}-ip-config"
      primary = true
      subnet_id = var.subnet_id
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
    }
  }

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}