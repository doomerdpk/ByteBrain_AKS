data "azurerm_user_assigned_identity" "this" {
name                = var.identity_name
resource_group_name = var.identity_resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = var.agent_pool_name
    node_count          = var.node_count
    vm_size             = var.node_vm_size
    vnet_subnet_id      = var.vnet_subnet_id
    max_pods            = 110
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.this.id]
  }

  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.enable_private_cluster_public_fqdn

  api_server_access_profile {
    authorized_ip_ranges = []
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = "azure"
    load_balancer_sku  = var.load_balancer_sku
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    outbound_type      = "userAssignedNATGateway"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.aad_admin_group_object_ids
    azure_rbac_enabled     = true
  }

  linux_profile {
    admin_username = "dpkaksuser"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.this.kube_admin_config[0].host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].cluster_ca_certificate)

  load_config_file = false
}

resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }

  depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_network_security_group" "aks" {
  name                = "${var.cluster_name}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowNodeOutboundInternet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "AllowKubeletToAPIServer"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureCloud"
  }
}


resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = var.vnet_subnet_id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_kubernetes_cluster_extension" "flux" {
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "backend" {
  name       = "backend-gitops"
  cluster_id = azurerm_kubernetes_cluster.this.id
  namespace  = "flux-system"

  git_repository {
    url             = var.git_repo_url
    reference_type  = var.branch_or_tag
    reference_value = var.git_repo_branch
  }

  kustomizations {
    name = var.kustomization_name
    path = var.kustomization_path
    garbage_collection_enabled = var.kustomization_prune
  }

  depends_on = [azurerm_kubernetes_cluster_extension.flux]
}

