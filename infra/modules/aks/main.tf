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
    enable_node_public_ip = false
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
  }

    data "azurerm_user_assigned_identity" "this" {
    name                = var.identity_name
    resource_group_name = var.identity_resource_group_name
    }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.this.id]
  }

  api_server_access_profile {
    enable_private_cluster                 = var.private_cluster_enabled
    enable_private_cluster_public_fqdn     = var.enable_private_cluster_public_fqdn
    authorized_ip_ranges                  = []
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = "azure"
    load_balancer_sku  = var.load_balancer_sku
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = "userAssignedNATGateway"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      admin_group_object_ids = var.aad_admin_group_object_ids
    }
  }

  linux_profile {
    admin_username = "dpkaksuser"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }
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

