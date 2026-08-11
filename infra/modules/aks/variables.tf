variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30.0"
}

variable "agent_pool_name" {
  description = "Name of the AKS agent pool"
  type        = string
  default     = "agentpool"
}

variable "node_count" {
  description = "Number of nodes in the AKS agent pool"
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "vnet_subnet_id" {
  description = "Subnet ID where AKS nodes will be deployed"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR block for AKS"
  type        = string
  default     = "10.2.0.0/24"
}

variable "dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
  default     = "10.2.0.10"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR"
  type        = string
  default     = "172.17.0.1/16"
}

variable "network_plugin" {
  description = "Kubernetes network plugin"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU for AKS"
  type        = string
  default     = "standard"
}

variable "private_cluster_enabled" {
  description = "Whether the AKS API server is private"
  type        = bool
  default     = true
}

variable "enable_private_cluster_public_fqdn" {
  description = "Whether to enable a public FQDN for the private AKS cluster API server"
  type        = bool
  default     = false
}


variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for AKS diagnostics"
  type        = string
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "identity_resource_group_name" {
  description = "Resource group name of the user-assigned managed identity"
  type        = string
}

variable "aad_admin_group_object_ids" {
  description = "AAD group object IDs who will be cluster admins"
  type        = list(string)
  default     = []
}

variable "service_principal_client_id" {
  description = "Optional service principal client ID for AKS"
  type        = string
  default     = null
}

variable "service_principal_client_secret" {
  description = "Optional service principal secret for AKS"
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}
