output "get_credentials" {
  value = "az aks get-credentials --name ${var.cluster_name} --resource-group ${var.resource_group_name} --admin"
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
