resource_group_name = "rg-bytebrain-aks"
location            = "East US"

acr_name = "acrbytebrainaks"

key_vault_name = "kvdpk01"

backend_image_name = "bytebrainbackend"
backend_image_tag = "30616c1edefe79c6d2f78490aa79ab6cc3d66f14"
frontend_image_name = "bytebrainfrontend"
frontend_image_tag = "5d1d2be159f4c1ceb5b8f33b8d13d1e127537aca"

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