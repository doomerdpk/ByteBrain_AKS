data "azurerm_user_assigned_identity" "this" {
  name                = var.identity_name
  resource_group_name = var.identity_resource_group_name
}


resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.this.id]
  }

  registry {
    server                    = var.acr_login_server
    identity                  =  data.azurerm_user_assigned_identity.this.id
  }

  dynamic "secret" {
    for_each = var.secrets
    content {
      name                = secret.value.name
      key_vault_secret_id = try(secret.value.key_vault_secret_id, null)
      identity            = try(secret.value.identity, null)
      value               = try(secret.value.value, null)
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.value.name
          value = env.value.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env_vars
        content {
          name        = env.value.name
          secret_name = env.value.secret_name
        }
      }
    }
  }

  ingress {
    external_enabled = var.external_ingress
    target_port      = var.target_port
    transport         = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  workload_profile_name = "Consumption"
}
