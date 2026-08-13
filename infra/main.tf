locals {
  bytebrain_tags = {
    Project   = "Bytebrain_AKS"
    ManagedBy = "Terraform"
  }
}

module "bytebrain_rg" {
  source = "./modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = local.bytebrain_tags
}

module "bytebrain_acr" {
  source = "./modules/acr"

  name                = var.acr_name
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  sku                 = "Standard"
  tags                = local.bytebrain_tags
}

module "key_vault" {
  source              = "./modules/key-vault"
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  key_vault_name      = var.key_vault_name
  tags                = local.bytebrain_tags
}

module "bytebrain_db_connection_string" {
  source       = "./modules/key-vault-secret"
  key_vault_id = module.key_vault.key_vault_id
  secret_name  = "bytebrain-db-connection-string"
  secret_value = var.db_connection_string
}

module "bytebrain_jwt_secret" {
  source       = "./modules/key-vault-secret"
  key_vault_id = module.key_vault.key_vault_id
  secret_name  = "bytebrain-jwt-secret"
  secret_value = var.jwt_secret
}

module "bytebrain_user_assigned_identity" {
  source              = "./modules/user-assigned-identity"
  name                = var.user_assigned_identity_name
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  acr_id              = module.bytebrain_acr.id
  key_vault_id        = module.key_vault.key_vault_id
  tags                = local.bytebrain_tags
}

module "bytebrain_backend_container" {
  source = "./modules/container-instance"

  name                = "bytebrain-backend"
  container_name      = "backend"
  identity_name       = module.bytebrain_user_assigned_identity.name
  identity_resource_group_name = module.bytebrain_rg.name
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  container_image     = "${module.bytebrain_acr.login_server}/${var.backend_image_name}:${var.backend_image_tag}"
  acr_login_server   = module.bytebrain_acr.login_server
  cpu                 = var.backend_cpu
  memory              = var.backend_memory
  port                = 3000
  restart_policy      = "Always"
  dns_name_label      = var.backend_dns_name_label
  environment_variables = {
  PORT                       = "3000"
  NODE_ENV                   = "production"
  KEY_VAULT_URI               = module.key_vault.key_vault_uri
  DB_CONNECTION_SECRET_NAME   = "bytebrain-db-connection-string"
  JWT_SECRET_SECRET_NAME      = "bytebrain-jwt-secret"
  AZURE_CLIENT_ID              = module.bytebrain_user_assigned_identity.client_id
  }
  tags = local.bytebrain_tags
}

module "bytebrain_frontend_container" {
  source = "./modules/container-instance"

  name                = "bytebrain-frontend"
  container_name      = "frontend"
  acr_login_server   = module.bytebrain_acr.login_server
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  identity_name       = module.bytebrain_user_assigned_identity.name
  identity_resource_group_name = module.bytebrain_rg.name
  container_image     = "${module.bytebrain_acr.login_server}/${var.frontend_image_name}:${var.frontend_image_tag}"
  cpu                 = var.frontend_cpu
  memory              = var.frontend_memory
  port                = 80
  restart_policy      = "Always"
  dns_name_label      = var.frontend_dns_name_label
  environment_variables = {
    NODE_ENV = "production"
  }
  tags = local.bytebrain_tags
}

module "bytebrain_vnet" {
  source = "./modules/vnet"

  name                = var.vnet_name
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  address_space = [
    "10.0.0.0/16"
  ]
  dns_servers = []
  tags = local.bytebrain_tags
}

module "bytebrain_subnet" {
  source              = "./modules/subnet"
  resource_group_name = module.bytebrain_rg.name
  vnet_name           = module.bytebrain_vnet.name
  subnet_name         = var.subnet_name
  address_prefixes    = ["10.0.1.64/26"]
  delegation = {
    name         = "container-apps-delegation"
    service_name = "Microsoft.App/environments"
  }
  tags                = local.bytebrain_tags
}


module "bytebrain_container_app_env" {
  source = "./modules/container-apps-environment"

  name                = var.container_app_env_name
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  infrastructure_subnet_id = module.bytebrain_subnet.subnet_id
  internal_load_balancer_enabled = false
  tags                = local.bytebrain_tags
}

module "bytebrain_backend_container_app" {
  source = "./modules/container-app"

  name                         = "bytebrain-backend-app"
  resource_group_name          = module.bytebrain_rg.name
  container_app_environment_id = module.bytebrain_container_app_env.id
  identity_name                = module.bytebrain_user_assigned_identity.name
  identity_resource_group_name = module.bytebrain_rg.name
  acr_login_server             = module.bytebrain_acr.login_server
  image                        = "${module.bytebrain_acr.login_server}/${var.backend_image_name}:${var.backend_image_tag}"
  cpu                          = var.backend_cpu_app
  memory                       = var.backend_memory_app
  min_replicas                 = 1
  max_replicas                 = 3
  external_ingress             = true
  target_port                  = 3000
  env_vars = [
  { name = "PORT", value = "3000" },
  { name = "NODE_ENV", value = "production" },
  { name = "KEY_VAULT_URI", value = module.key_vault.key_vault_uri },
  { name = "DB_CONNECTION_SECRET_NAME", value = "bytebrain-db-connection-string" },
  { name = "JWT_SECRET_SECRET_NAME", value = "bytebrain-jwt-secret" },
  { name = "AZURE_CLIENT_ID", value = module.bytebrain_user_assigned_identity.client_id },
]
  tags = local.bytebrain_tags
}

module "bytebrain_frontend_container_app" {
  source = "./modules/container-app"

  name                         = "bytebrain-frontend-app"
  resource_group_name          = module.bytebrain_rg.name
  container_app_environment_id = module.bytebrain_container_app_env.id
  identity_name                = module.bytebrain_user_assigned_identity.name
  identity_resource_group_name = module.bytebrain_rg.name
  acr_login_server             = module.bytebrain_acr.login_server
  image                        = "${module.bytebrain_acr.login_server}/${var.frontend_image_name}:${var.frontend_image_tag}"
  cpu                          = var.frontend_cpu_app
  memory                       = var.frontend_memory_app
  min_replicas                 = 1
  max_replicas                 = 3
  external_ingress             = true
  target_port                  = 80
  env_vars                     = [
    { name = "NODE_ENV", value = "production" },
    { name = "BACKEND_URL", value = "https://${module.bytebrain_backend_container_app.fqdn}" }
  ]
  tags = local.bytebrain_tags
} 


module "bytebrain_frontend" {

  source = "./modules/static-web-app"

  name                = var.static_web_app_name
  resource_group_name = module.bytebrain_rg.name
  location = "EAST US2"

  tags = local.bytebrain_tags
}

module "azure_bastion" {
  source = "./modules/azure-bastion"

  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  tags                = local.bytebrain_tags

  vnet_id   = module.bytebrain_vnet.id
  vnet_name = module.bytebrain_vnet.name

  bastion_subnet_address_prefix = "10.0.1.0/26"
  bastion_host_name             = var.bastion_host_name

  sku                = var.sku
  enable_diagnostics = false

#   allowed_source_address_prefixes = [
#   "103.177.82.129/32",
#   "203.191.35.125/32"
# ]

allowed_source_address_prefixes = ["*"]
}


module "log_analytics" {
  source              = "./modules/log-analytics"
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  workspace_name      = var.log_analytics_workspace_name
  tags                = local.bytebrain_tags
}

module "bytebrain_aks_subnet" {
  source              = "./modules/subnet"
  resource_group_name = module.bytebrain_rg.name
  vnet_name           = module.bytebrain_vnet.name
  subnet_name         = var.aks_subnet_name
  address_prefixes    = ["10.0.2.0/24"]
  tags                = local.bytebrain_tags
}

module "nat_gateway" {
  source              = "./modules/nat-gateway"
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  nat_gateway_name    = var.nat_gateway_name
  public_ip_name      = var.public_ip_name
  subnet_id           = module.bytebrain_aks_subnet.subnet_id
  tags                = local.bytebrain_tags
}


module "bytebrain_aks" {
  source              = "./modules/aks"
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  cluster_name        = var.aks_cluster_name
  dns_prefix         = var.aks_dns_prefix
  kubernetes_version = var.kubernetes_version
  agent_pool_name     = var.aks_agent_pool_name
  node_count         = var.aks_node_count
  node_vm_size       = var.aks_node_vm_size
  vnet_subnet_id      = module.bytebrain_aks_subnet.subnet_id
  service_cidr        = var.aks_service_cidr
  dns_service_ip      = var.aks_dns_service_ip
  private_cluster_enabled = var.aks_private_cluster_enabled
  enable_private_cluster_public_fqdn = var.aks_enable_private_cluster_public_fqdn
  log_analytics_workspace_id = module.log_analytics.log_analytics_workspace_id
  identity_name       = module.bytebrain_user_assigned_identity.name
  identity_resource_group_name = module.bytebrain_rg.name
  ssh_public_key     = var.ssh_public_key
  key_vault_id       = module.key_vault.key_vault_id
  git_repo_url        = var.git_repo_url
  tags                = local.bytebrain_tags
}

module "jump_vm_aks" {
  source              = "./modules/jump-vm-aks"
  resource_group_name = module.bytebrain_rg.name
  location            = module.bytebrain_rg.location
  vnet_name           = module.bytebrain_vnet.name
  subnet_name         = var.jumpbox_subnet_name
  subnet_prefix       = var.jumpbox_subnet_prefix
  vm_name             = var.vm_name
  nic_name            = var.nic_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_key_data        = var.ssh_public_key
  aks_cluster_id      = module.bytebrain_aks.aks_id
  tags                = local.bytebrain_tags
}

resource "azurerm_subnet_nat_gateway_association" "jumpbox" {
  subnet_id      = module.jump_vm_aks.jumpbox_subnet_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}
