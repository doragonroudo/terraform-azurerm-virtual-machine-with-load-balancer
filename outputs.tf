output "resource_group" {
  value = azurerm_resource_group.main
}

output "suffix" {
  value = local.suffix
}

output "domain_name_label" {
  value = local.domain_name_label
}

output "ssh_port" {
  value = local.ssh_port
}

# output "kubectl_port" {
#   value = local.kubectl_port
# }

# output "http_port" {
#   value = local.http_port
# }

# output "https_port" {
#   value = local.https_port
# }

output "public_key" {
  value = local.public_key
}

output "private_key" {
  value     = tls_private_key.main.private_key_pem
  sensitive = true
}

output "network_security_group" {
  value = azurerm_network_security_group.default
}

output "virtual_network" {
  value = azurerm_virtual_network.main
}

output "linux_virtual_machine" {
  value     = azurerm_linux_virtual_machine.main
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.main
}

output "lb" {
  value = azurerm_lb.main
}

# output "ip_address" {
#   value = local.ip_address
# }

output "email" {
  value = local.email
}

output "location" {
  value = local.location
}
