resource_group_name = "rg-bytebrain-aks"
location            = "East US"

acr_name = "acrbytebrainaks"

key_vault_name = "kvdpk01"

backend_image_name = "bytebrainbackend"
backend_image_tag = "30616c1edefe79c6d2f78490aa79ab6cc3d66f14"
frontend_image_name = "bytebrainfrontend"
frontend_image_tag = "2be1d12ced03964e55fb8f06843810bbb4ce4e61"

backend_cpu = 1
backend_memory = 2
frontend_cpu = 1
frontend_memory = 2

backend_dns_name_label  = "bytebrain-backend"
frontend_dns_name_label = "bytebrain-frontend"

user_assigned_identity_name = "id-bytebrain-aks-eastus"