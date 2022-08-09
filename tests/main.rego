package main

terraform = [file | file := input[_]; file.path == "main.tf"][0].contents

# Azure Provider

deny[msg] {
	not terraform.provider.azurerm
	msg = "Azure provider should be defined"
}

# Required Modules

deny[msg] {
	not terraform.module.kubernetes
	msg = "Kubernetes module should be defined"
}

deny[msg] {
	not terraform.module.kubernetes.source == "./modules/kubernetes"
	msg = "Should import local Kubernetes module"
}
