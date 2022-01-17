variable "client_id" {
  default = "cb656ed1-c7a6-4d09-be70-bd9472a3a02a"
}

variable "akv_id" {
  default = "/subscriptions/013baf31-283f-4e64-a3e2-2e638a891d02/resourceGroups/sampledatastack/providers/Microsoft.KeyVault/vaults/akvaamvsampledatastack"
}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "aamvsampledatastack"
}

variable "cluster_name" {
  default = "akssampledatastack"
}

variable "resource_group_name" {
  default = "sampledatastack"
}

variable "location" {
  default = "West Europe"
}

variable "log_analytics_workspace_name" {
  default = "lawsdgusecase"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable "log_analytics_workspace_location" {
  default = "westeurope"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}