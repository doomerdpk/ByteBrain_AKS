variable "name" {
  description = "Name of the User-Assigned Managed Identity."
  type        = string

  validation {
    condition     = length(var.name) > 3 && length(var.name) <= 128
    error_message = "The identity name must be between 3 and 128 characters."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the identity."
  type        = string
}

variable "location" {
  description = "Azure region where the identity will be created."
  type        = string
}

variable "acr_id" {
  description = "ID of the Azure Container Registry used to pull images"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "ID of the Azure Key Vault used to store secrets"
  type        = string
  default     = null
}


variable "tags" {
  description = "A map of tags to apply to the resource."
  type        = map(string)
  default     = {}
}



