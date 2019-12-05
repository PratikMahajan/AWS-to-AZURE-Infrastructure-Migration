resource "azurerm_public_ip" "app_gtway_public_ip" {
  name                = "appgtway-pip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku = "Standard"
}

locals {
  backend_address_pool_name      = "${var.az_virtual_network_name}-beap"
  frontend_port_name             = "${var.az_virtual_network_name}-feport"
  frontend_ip_configuration_name = "${var.az_virtual_network_name}-feip"
  http_setting_name              = "${var.az_virtual_network_name}-be-htst"
  listener_name                  = "${var.az_virtual_network_name}-httplstn"
  request_routing_rule_name      = "${var.az_virtual_network_name}-rqrt"
  redirect_configuration_name    = "${var.az_virtual_network_name}-rdrcfg"
}


resource "azurerm_application_gateway" "network" {
  name                = "appgateway"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id_appgateway
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = azurerm_public_ip.app_gtway_public_ip.id
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  ssl_certificate {
    data = filebase64("${var.cert_path}")
    name = "imp-cert"
    password = var.cert_password
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Https"
    ssl_certificate_name           = "imp-cert"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_version = "3.1"
  }
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
  upgrade_policy_mode  = "Manual"
  automatic_os_upgrade = false
//  health_probe_id      = azurerm_lb_probe.ssh.id


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
      application_gateway_backend_address_pool_ids =["${azurerm_application_gateway.network.backend_address_pool[0].id}"]
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


resource "azurerm_monitor_autoscale_setting" "scaling_policies" {
  name                = "autoscale-cpu"
  target_resource_id  = azurerm_virtual_machine_scale_set.vm.id
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  profile {
    name = "autoscale-cpu"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vm.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.vm_increase_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vm.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.vm_decrease_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}