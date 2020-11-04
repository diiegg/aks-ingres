# Azure Nginx ingress

**Topics**

Terraform module which provide an ak8s and Nginx ingress controller using terraform and Helm
The following resources are created:

 - Basic Kubernetes cluster
 - Vnet
 - Nginx ingress controller
 - 
![enter image description here](https://user-images.githubusercontent.com/12648295/98110796-8bd7c200-1e97-11eb-8116-1ab6cc55a525.png)
   
## Requisites
 
- Azure Account
- Terraform

 ## Requirements

| Name | Version |
|--|--|
|  terraform| >= 0.12  |

## Providers

|Name| Version
|--|--|
| Azure | N/A |
  
### Terraform Version

Terraform 0.12. Pin module version to ⇾ v2.0. Submit pull-requests to master branch.

### Description


## Usage

Log in into azure console

  ```sh
https://github.com/diiegg/aks-ingres.git

cd Terraform_ALB_AWS

terraform init

terrafom plan

terraform apply

```

## Module
  ```sh
  provider "azurerm" {

#The "feature" block is required for AzureRM provider 2.x.

#If you are using version 1.x, the "features" block is not allowed.

version = "~>2.0"

features {}

}

#Create a virtual network in the production-resources resource group

resource "azurerm_virtual_network" "test" {

name = "production-network"

resource_group_name = "${azurerm_resource_group.example.name}"

location = "${azurerm_resource_group.example.location}"

address_space = ["10.0.0.0/16"]

}

resource "azurerm_resource_group" "k8s" {

name = var.resource_group_name

location = var.location

}

resource "azurerm_kubernetes_cluster" "k8s" {

name = var.cluster_name

location = azurerm_resource_group.k8s.location

resource_group_name = azurerm_resource_group.k8s.name

dns_prefix = var.dns_prefix

default_node_pool {

name = "default"

node_count = var.node_count

vm_size = "Standard_DS2_v2"

enable_auto_scaling = false

}

identity {

type = "SystemAssigned"

}

addon_profile {

oms_agent {

enabled = false

}

aci_connector_linux {

enabled = false

}

kube_dashboard {

enabled = false

}

http_application_routing {

enabled = false

}

azure_policy {

enabled = false

}

}

tags = {

Environment = "Development"

}

}
``` 

## Nginx Ingress Controller Module

   ```sh
provider "helm" {
  kubernetes {
    load_config_file       = "false"
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}

#following this tutorial https://docs.microsoft.com/en-us/azure/aks/ingress-basic
data "helm_repository" "nginx-ingress" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}

resource "helm_release" "nginx-ingress" {
  name             = "nginx-ingress"
  namespace        = "nginx-ingress"
  create_namespace = true
  repository       = data.helm_repository.nginx-ingress.name
  chart            = "nginx-ingress"

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "defaultBackend.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }
}

```
# Demo

http://52.224.78.42

http://52.224.78.42/hello-world-two

License.
----
MIT

# References.

  

- [Terraform aks](https://learn.hashicorp.com/tutorials/consul/hashicorp-consul-service-aks)

- [K8s azure](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress)
