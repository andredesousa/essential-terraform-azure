# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
}

# Import required Terraform modules

module "kubernetes" {
  source = "./modules/kubernetes"

  resource_group_name           = "sample-rg"
  container_registry_name       = "andredesousaregistry"
  kubernetes_cluster_name       = "sample-aks"
  kubernetes_cluster_dns_prefix = "sample-k8s"
}
