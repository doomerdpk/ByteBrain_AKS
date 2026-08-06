output "id" {
  description = "ID of the container group"
  value       = azurerm_container_group.this.id
}

output "name" {
  description = "Name of the container group"
  value       = azurerm_container_group.this.name
}

output "ip_address" {
  description = "Public IP address of the container group"
  value       = azurerm_container_group.this.ip_address
}

output "fqdn" {
  description = "Fully qualified domain name of the container group"
  value       = azurerm_container_group.this.fqdn
}

output "principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_container_group.this.identity[0].principal_id
}
