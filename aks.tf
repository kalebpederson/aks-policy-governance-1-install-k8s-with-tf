terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.93.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "aks_cluster_rg" {
  name     = "${var.project_name}-rg"
  location = var.target_region
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name = "${var.project_name}-aks"
  location = azurerm_resource_group.aks_cluster_rg.location
  resource_group_name = azurerm_resource_group.aks_cluster_rg.name
  dns_prefix = "${var.project_name}-aks"

  default_node_pool {
    name = "default"
    node_count = 1
    # (2 core, 4 GiB memory) is the minimum required (e.g., Standard_B2s)
    # the B2as_v2 has 8 GiB of memory
    vm_size = "Standard_B2as_v2"
    temporary_name_for_rotation = "temprotate"
  }

  identity {
    type = "SystemAssigned"
  }

  # disable the Azure Policy Addon so it doesn't interfere with our Gatekeeper install
  azure_policy_enabled = false
  
  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled     = true
  }

  tags = {
    Environment = var.environment
  }
}
