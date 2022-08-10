# Create a resource group
resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = "eastus"

  tags = {
    environment = "production"
  }
}

# Create a container registry within the resource group
resource "azurerm_container_registry" "default" {
  name                = var.container_registry_name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Standard"
  admin_enabled       = false
}

# Create a kubernetes cluster within the resource group
resource "azurerm_kubernetes_cluster" "default" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = var.kubernetes_cluster_dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "production"
  }
}

# Attaching a container registry to a Kubernetes cluster
resource "azurerm_role_assignment" "default" {
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}
