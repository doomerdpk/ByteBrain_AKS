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