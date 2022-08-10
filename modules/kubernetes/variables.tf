variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "container_registry_name" {
  description = "Azure container registry name"
  type        = string
}

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "kubernetes_cluster_dns_prefix" {
  description = "Kubernetes DNS prefix"
  type        = string
}
