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