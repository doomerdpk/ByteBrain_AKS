variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "acr_name" {
  description = "Globally unique ACR name (letters/numbers only, no hyphens, 5-50 chars)"
  type        = string
  default     = "acrbytebraindev01"
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "db_connection_string" {
  type        = string
  description = "Database connection string for the backend"
  sensitive   = true
}

variable "jwt_secret" {
  type        = string
  description = "JWT signing secret for backend authentication"
  sensitive   = true
}