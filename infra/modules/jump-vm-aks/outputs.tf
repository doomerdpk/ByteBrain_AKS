output "jumpbox_subnet_id" {
  value = azurerm_subnet.jumpbox.id
}

output "jumpbox_public_ip" {
  value = azurerm_public_ip.jumpbox.ip_address
}

output "jumpbox_private_ip" {
  value = azurerm_network_interface.jumpbox.private_ip_address
}

output "jumpbox_vm_id" {
  value = azurerm_linux_virtual_machine.jumpbox.id
}
