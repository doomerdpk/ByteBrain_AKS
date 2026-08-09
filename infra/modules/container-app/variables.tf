variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_app_environment_id" {
  type = string
}

variable "identity_id" {
  type        = string
  description = "Resource ID of the User Assigned Managed Identity"
}

variable "acr_login_server" {
  type = string
}

variable "acr_identity_id" {
  type        = string
  description = "Resource ID of the identity (must be in identity_ids) used to pull from ACR"
}

variable "image" {
  type        = string
  description = "Full image reference, e.g. myacr.azurecr.io/backend:abc1234"
}

variable "cpu" {
  type    = number
  default = 0.5
}

variable "memory" {
  type    = string
  default = "1Gi"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "target_port" {
  type = number
}

variable "external_ingress" {
  type    = bool
  default = true
}

variable "env_vars" {
  description = "Plain env vars. Each item: { name, value }"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secret_env_vars" {
  description = "Env vars sourced from a secret defined in `secrets`. Each item: { name, secret_name }"
  type = list(object({
    name        = string
    secret_name = string
  }))
  default = []
}

variable "secrets" {
  description = "Container App secrets. Provide either key_vault_secret_id (+ identity) or a plain value."
  type = list(object({
    name                = string
    key_vault_secret_id = optional(string)
    identity             = optional(string)
    value                = optional(string)
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
