variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Set this if you want the environment injected into your own VNet (needed for private/internal ingress to the backend)."
  default     = null
}

variable "internal_load_balancer_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
