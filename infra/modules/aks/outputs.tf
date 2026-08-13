output "aks_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kube_admin_config_host" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config[0].host
  sensitive = true
}
output "kube_admin_config_client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config[0].client_certificate
  sensitive = true
}
output "kube_admin_config_client_key" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config[0].client_key
  sensitive = true
}
output "kube_admin_config_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config[0].cluster_ca_certificate
  sensitive = true
}