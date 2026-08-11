output "jumpbox_private_ip" {
  value = azurerm_network_interface.jumpbox.private_ip_address
}

output "jumpbox_vm_id" {
  value = azurerm_linux_virtual_machine.jumpbox.id
}
