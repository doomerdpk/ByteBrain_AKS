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

variable "backend_image_name" {
  description = "Name of the backend image in ACR, without the registry prefix"
  type        = string
  default     = "bytebrain-backend"
}

variable "backend_image_tag" {
  description = "Tag of the backend image in ACR"
  type        = string
  default     = "latest"
}

variable "frontend_image_name" {
  description = "Name of the frontend image in ACR, without the registry prefix"
  type        = string
  default     = "bytebrain-frontend"
}

variable "frontend_image_tag" {
  description = "Tag of the frontend image in ACR"
  type        = string
  default     = "latest"
}

variable "backend_cpu" {
  description = "CPU cores allocated to the backend container instance"
  type        = number
  default     = 1
}

variable "backend_memory" {
  description = "Memory in GB allocated to the backend container instance"
  type        = number
  default     = 2
}

variable "frontend_cpu" {
  description = "CPU cores allocated to the frontend container instance"
  type        = number
  default     = 1
}

variable "frontend_memory" {
  description = "Memory in GB allocated to the frontend container instance"
  type        = number
  default     = 2
}

variable "backend_dns_name_label" {
  description = "Optional DNS label for the backend container group"
  type        = string
  default     = null
}

variable "frontend_dns_name_label" {
  description = "Optional DNS label for the frontend container group"
  type        = string
  default     = null
}

variable "user_assigned_identity_name" {
  description = "Name of the User-Assigned Managed Identity"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the Subnet within the Virtual Network"
  type        = string
}

variable "container_app_env_name" {
  description = "Name of the Azure Container Apps Environment"
  type        = string
}

variable "backend_cpu_app" {
  description = "CPU cores allocated to the backend container app"
  type        = number
  default     = 1
}

variable "backend_memory_app" {
  description = "Memory allocated to the backend container app"
  type        = string
  default     = "1Gi"
}

variable "frontend_cpu_app" {
  description = "CPU cores allocated to the frontend container app"
  type        = number
  default     = 1
}

variable "frontend_memory_app" {
  description = "Memory allocated to the frontend container app"
  type        = string
  default     = "1Gi"
}

variable "static_web_app_name" {
  description = "Name of the static web app to deploy react frontend"
  type        = string
}

variable "bastion_host_name" {
  description = "Name of the Azure Bastion Host"
  type        = string
}

variable "sku" {
  description = "SKU of the Azure Bastion Host"
  type        = string
}

