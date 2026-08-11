resource_group_name = "rg-bytebrain-aks"
location            = "East US"

acr_name = "acrbytebrainaks"

key_vault_name = "kvdpk01"

backend_image_name = "bytebrainbackend"
backend_image_tag = "30616c1edefe79c6d2f78490aa79ab6cc3d66f14"
frontend_image_name = "bytebrainfrontend"
frontend_image_tag = "580603c989d6553532796c90f22f839a3898b077"

backend_cpu = 2
backend_memory = 2
frontend_cpu = 1
frontend_memory = 2

backend_dns_name_label  = "bytebrain-backend"
frontend_dns_name_label = "bytebrain-frontend"

user_assigned_identity_name = "id-bytebrain-aks-eastus"

vnet_name                = "vnet-bytebrain-aks"

subnet_name              = "snet-bytebrain-container-apps"

container_app_env_name = "env-bytebrain-container-apps"

backend_cpu_app    = 2
backend_memory_app = "4Gi"

frontend_cpu_app    = 1
frontend_memory_app = "2Gi"

static_web_app_name = "bytebrain-aks-fe"

bastion_host_name = "dpk-bastion-01"
sku = "Basic"

nat_gateway_name = "dpk-ng-01"
public_ip_name = "dpk-pip-01"

log_analytics_workspace_name = "dpk-workspace-01"

aks_subnet_name = "snet-bytebrain-aks"

aks_cluster_name = "bytebrain-aks-01"
aks_dns_prefix = "bytebrainaks"
kubernetes_version = "1.34.9"
aks_agent_pool_name = "bbagentpool"
aks_node_count = 1
aks_node_vm_size = "Standard_D2as_v7"
aks_service_cidr = "10.2.0.0/24"
aks_dns_service_ip = "10.2.0.10"
aks_private_cluster_enabled = true
aks_enable_private_cluster_public_fqdn = false

vm_name = "jumpbox-vm-aks"
nic_name = "jumpbox-vm-aks-nic"
admin_username = "azureuser"