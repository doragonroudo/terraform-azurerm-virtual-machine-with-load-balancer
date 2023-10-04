resource "azurerm_public_ip" "main" {
  name                = module.naming.public_ip.name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  allocation_method = "Static"
  availability_zone = "No-Zone"
  domain_name_label = local.domain_name_label
  sku               = "Standard"
  sku_tier          = "Regional"
  ip_version        = "IPv4"
}

resource "azurerm_lb" "main" {
  name                = module.naming.lb.name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  sku      = "Standard"
  sku_tier = "Regional"

  frontend_ip_configuration {
    name                 = azurerm_public_ip.main.name
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = azurerm_linux_virtual_machine.main.name
}

resource "azurerm_lb_backend_address_pool_address" "main" {
  name                    = azurerm_network_interface.main.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
  virtual_network_id      = azurerm_virtual_network.main.id
  ip_address              = azurerm_linux_virtual_machine.main.private_ip_address
}

resource "azurerm_lb_probe" "vm_main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "ssh"
  protocol            = "Tcp"
  port                = local.ssh_vm_port
  interval_in_seconds = 5
}

resource "azurerm_lb_rule" "ssh" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "rule-ssh"

  protocol                       = "Tcp"
  frontend_port                  = local.ssh_port
  backend_port                   = local.ssh_vm_port
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.vm_main.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "rule-outbound"

  protocol                 = "All"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.main.id
  allocated_outbound_ports = 1024
  enable_tcp_reset         = true

  frontend_ip_configuration {
    name = azurerm_lb.main.frontend_ip_configuration[0].name
  }
}
