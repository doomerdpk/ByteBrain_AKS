terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-state"
    storage_account_name = "dpktfstate"
    container_name       = "tfstate"
    key                  = "bytebrainaks.tfstate"
    use_azuread_auth     = true
  }
}