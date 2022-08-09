# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
}

# Import required Terraform modules

module "kubernetes" {
  source = "./modules/kubernetes"
}
