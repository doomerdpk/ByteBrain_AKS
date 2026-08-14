resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  dynamic "delegation" {
    for_each = var.delegation != null ? [var.delegation] : []

    content {
      name = delegation.value.name

      service_delegation {
        name = delegation.value.service_name
        actions = try(delegation.value.actions, ["Microsoft.Network/virtualNetworks/subnets/join/action"])
      }
    }
  }
}