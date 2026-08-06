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