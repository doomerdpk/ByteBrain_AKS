output "id" {
  description = "The resource ID of the User-Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "The name of the identity."
  value       = azurerm_user_assigned_identity.this.name
}