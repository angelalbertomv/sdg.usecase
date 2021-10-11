variable "client_id" {
  default = "bb19071b-61f3-4b5b-92dd-f3c8fef1f663"
}

variable "akv_id" {
  default = "/subscriptions/013baf31-283f-4e64-a3e2-2e638a891d02/resourceGroups/sdgusecase/providers/Microsoft.KeyVault/vaults/akvsdgusecase"
}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "sdgusecase"
}

variable "cluster_name" {
  default = "akssdgusecase"
}

variable "resource_group_name" {
  default = "sdgusecase"
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