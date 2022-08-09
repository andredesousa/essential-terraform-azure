output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "container_registry_name" {
  value = azurerm_container_registry.default.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}
