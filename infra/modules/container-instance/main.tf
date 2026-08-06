resource "azurerm_container_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy
  dns_name_label      = var.dns_name_label
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = "TCP"
    }

    environment_variables = var.environment_variables
    secure_environment_variables = var.secure_environment_variables
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  count                = var.enable_acr_pull ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_group.this.identity[0].principal_id

  depends_on = [azurerm_container_group.this]
}
