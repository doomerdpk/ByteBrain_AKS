variable "name" {
  description = "Name of the Azure Container Instance group"
  type        = string
}

variable "container_name" {
  description = "Name of the container inside the container group"
  type        = string
  default     = "app"
}

variable "resource_group_name" {
  description = "Resource group where the container instance will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "container_image" {
  description = "Container image reference, including registry server and tag"
  type        = string
}

variable "cpu" {
  description = "CPU cores allocated to the container"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in GB allocated to the container"
  type        = number
  default     = 2
}

variable "port" {
  description = "Container port to expose"
  type        = number
  default     = 80
}

variable "restart_policy" {
  description = "Restart policy for the container group"
  type        = string
  default     = "Always"
}

variable "dns_name_label" {
  description = "Optional DNS label for the public IP address"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Non-sensitive environment variables"
  type        = map(string)
  default     = {}
}

variable "secure_environment_variables" {
  description = "Sensitive environment variables"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "acr_id" {
  description = "ID of the Azure Container Registry used to pull images"
  type        = string
  default     = null
}

variable "enable_acr_pull" {
  description = "Grant AcrPull to the container instance's managed identity"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the container instance"
  type        = map(string)
  default     = {}
}
