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

output "backend_container_fqdn" {
  description = "FQDN of the backend container instance"
  value       = module.bytebrain_backend_container.fqdn
}

output "backend_container_ip" {
  description = "Public IP of the backend container instance"
  value       = module.bytebrain_backend_container.ip_address
}

output "frontend_container_fqdn" {
  description = "FQDN of the frontend container instance"
  value       = module.bytebrain_frontend_container.fqdn
}

output "frontend_container_ip" {
  description = "Public IP of the frontend container instance"
  value       = module.bytebrain_frontend_container.ip_address
}

output "user_assigned_identity_id" {
  description = "ID of the User-Assigned Managed Identity"
  value       = module.bytebrain_user_assigned_identity.id
}

output "user_assigned_identity_client_id" {
  description = "Client ID of the User-Assigned Managed Identity"
  value       = module.bytebrain_user_assigned_identity.client_id
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.bytebrain_vnet.id
}

output "subnet_id" {
  description = "ID of the Subnet within the Virtual Network"
  value       = module.bytebrain_subnet.subnet_id
}

output "container_app_environment_id" {
  description = "ID of the Azure Container Apps Environment"
  value       = module.bytebrain_container_app_env.id
}

output "static_web_app_id" {
  description = "ID of the Static web app"
  value       = module.bytebrain_frontend.id
}

output "static_web_app_hostname" {
  description = "Hostname of the static web apps"
  value       = module.bytebrain_frontend.default_hostname
}

output "bastion_host_id" {
  description = "Azure Bastion Host ID"
  value       = module.azure_bastion.bastion_host_id
}

output "bastion_host_name" {
  description = "Azure Bastion Host Name"
  value       = module.azure_bastion.bastion_host_name
}

output "bastion_public_ip_address" {
  description = "Azure Bastion Public IP Address"
  value       = module.azure_bastion.bastion_public_ip_address
}

output "bastion_subnet_id" {
  description = "Azure Bastion Subnet ID"
  value       = module.azure_bastion.bastion_subnet_id
}

output "bastion_nsg_id" {
  description = "Azure Bastion Network Security Group ID"
  value       = module.azure_bastion.nsg_id
}

output "nat_gateway_id" {
  description = "Azure NAT Gateway ID"
  value       = module.nat_gateway.nat_gateway_id
}

output "nat_public_ip_address" {
  description = "Public IP Address associated with the NAT Gateway"
  value       = module.nat_gateway.public_ip_address
}