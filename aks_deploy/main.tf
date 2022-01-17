provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  skip_provider_registration = true
}

terraform {
  backend "azurerm" {}
}

data "azurerm_resource_group" "k8s" {
  name = var.resource_group_name
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "law" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = data.azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "spn"
  key_vault_id = var.akv_id
}


resource "azurerm_log_analytics_solution" "las" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.law.location
  resource_group_name   = data.azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = data.azurerm_key_vault_secret.client_secret.value
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Test"
  }
}

resource "azurerm_dns_zone" "sampledatastack" {
  name                = "sampledatastack.tk"
  resource_group_name = data.azurerm_resource_group.k8s.name
}

/*
resource "azurerm_eventhub_namespace" "eventnamespace" {
  name                = "unicctestcasenms"
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "UNICC"
  }
}

resource "azurerm_eventhub" "eventhub" {
  name                = "shares_prices"
  namespace_name      = azurerm_eventhub_namespace.eventnamespace.name
  resource_group_name = data.azurerm_resource_group.k8s.name
  partition_count     = 2
  message_retention   = 1

  capture_description {
    enabled  = true
    encoding = "Avro"

    destination {
      name = "EventHubArchive.AzureBlockBlob"

      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}-{Month}-{Day}T{Hour}:{Minute}:{Second}"
      blob_container_name = "stageunicc"
      storage_account_id  = "/subscriptions/013baf31-283f-4e64-a3e2-2e638a891d02/resourceGroups/sdgusecase/providers/Microsoft.Storage/storageAccounts/stasdgusecase"
    }
  }
}
*/
