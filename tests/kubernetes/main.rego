package kubernetes

terraform = [file | file := input[_]; file.path == "modules/kubernetes/main.tf"][0].contents

# Azure Resource Group

deny[msg] {
	not terraform.resource.azurerm_resource_group
	msg = "Resource group should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_resource_group["default"].name
	msg = "Resource group name should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_resource_group["default"].location == "eastus"
	msg = "Resource group location should be 'eastus'"
}

deny[msg] {
	not terraform.resource.azurerm_resource_group["default"].tags.environment == "production"
	msg = "Resource group includes 'production' tag"
}

# Azure Container Registry

deny[msg] {
	not terraform.resource.azurerm_container_registry
	msg = "Container registry should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_container_registry["default"].name
	msg = "Container registry name should be defined"
}

deny[msg] {
	not contains(terraform.resource.azurerm_container_registry["default"].location, "azurerm_resource_group.default.location")
	msg = "Container registry location should be defined"
}

deny[msg] {
	not contains(terraform.resource.azurerm_container_registry["default"].resource_group_name, "azurerm_resource_group.default.name")
	msg = "Container registry group name should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_container_registry["default"].sku == "Standard"
	msg = "Container registry sku should be 'Standard'"
}

deny[msg] {
	not terraform.resource.azurerm_container_registry["default"].admin_enabled == false
	msg = "Container registry admin mode should be disabled"
}

# Azure Kubernetes Service

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster
	msg = "Kubernetes cluster should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster["default"].name
	msg = "Kubernetes cluster name should be defined"
}

deny[msg] {
	not contains(terraform.resource.azurerm_kubernetes_cluster["default"].location, "azurerm_resource_group.default.location")
	msg = "Kubernetes cluster location should be defined"
}

deny[msg] {
	not contains(terraform.resource.azurerm_kubernetes_cluster["default"].resource_group_name, "azurerm_resource_group.default.name")
	msg = "Kubernetes cluster group name should be defined"
}

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster["default"].default_node_pool.name == "default"
	msg = "Kubernetes cluster node pool name should be 'default'"
}

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster["default"].default_node_pool.node_count == 1
	msg = "Kubernetes cluster node pool should contain 1 node"
}

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster["default"].default_node_pool.vm_size == "Standard_D2_v2"
	msg = "Kubernetes cluster node pool size should be 'Standard_D2_v2'"
}

deny[msg] {
	not terraform.resource.azurerm_kubernetes_cluster["default"].tags.environment == "production"
	msg = "Kubernetes cluster includes 'production' tag"
}

# Role Assignment

deny[msg] {
	not terraform.resource.azurerm_role_assignment
	msg = "Role assignment should be defined"
}
