variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "vnet_name" {
  description = "Existing virtual network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name for the jumpbox"
  type        = string
}

variable "subnet_prefix" {
  description = "CIDR for the jumpbox subnet"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the jumpbox VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_key_data" {
  description = "Public SSH key for the jumpbox VM"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "public_ip_name" {
  description = "Public IP name for the jumpbox"
  type        = string
  default     = null
}

variable "assign_public_ip" {
  description = "Whether the jumpbox should be assigned a public IP"
  type        = bool
  default     = false
}

variable "nic_name" {
  description = "Name for the network interface"
  type        = string
}

variable "vm_name" {
  description = "Name of the jumpbox VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the jumpbox VM"
  type        = string
  default     = "Standard_B2ms"
}
