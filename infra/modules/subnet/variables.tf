variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "delegation" {
  description = "Optional subnet delegation configuration."

  type = object({
    name         = string
    service_name = string
    actions      = optional(list(string))
  })

  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}