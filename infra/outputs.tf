output "resource_group_id" {
  description = "Resource group ID of the Bytebrain resource group"
  value       = module.bytebrain_rg.id
}

output "resource_group_name" {
  description = "Name of the Bytebrain resource group"
  value       = module.bytebrain_rg.name
}

output "resource_group_location" {
  description = "Location of the Bytebrain resource group"
  value       = module.bytebrain_rg.location
}

output "acr_id" {
  description = "ID of the Bytebrain Azure Container Registry"
  value       = module.bytebrain_acr.id
}

output "acr_name" {
  description = "Name of the Bytebrain Azure Container Registry"
  value       = module.bytebrain_acr.name
}

output "acr_login_server" {
  description = "Login server of the Bytebrain Azure Container Registry"
  value       = module.bytebrain_acr.login_server
}

output "key_vault_id" {
  description = "ID of the Bytebrain Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Bytebrain Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "key_vault_name" {
  description = "Name of the Bytebrain Key Vault"
  value       = module.key_vault.key_vault_name
}