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

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Key Vault the AKS identity needs access to"
}

variable "git_repo_url" {
  type        = string
  description = "URL of the GitOps repository"
}

variable "git_repo_branch" {
  type        = string
  description = "Branch of the GitOps repository"
  default     = "master"
}

variable "branch_or_tag" {
  type        = string
  description = "Branch or tag of the GitOps repository"
  default     = "branch"
}

variable "kustomization_name" {
  type        = string
  description = "Name of the Kustomization"
  default     = "backend"
}

variable "kustomization_path" {
  type        = string
  description = "Path of the Kustomization"
  default     = "./manifests"
}

variable "kustomization_prune" {
  type        = bool
  description = "Whether to enable pruning for the Kustomization"
  default     = true
}

variable "jumpbox_principal_id" {
  type        = string
  description = "Principal (object) ID of the jumpbox's managed identity"
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry the AKS identity needs access to"
}
