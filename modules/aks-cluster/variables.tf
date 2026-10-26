variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string; default = "1.29" }
variable "default_node_pool" {
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    vnet_subnet_id      = string
    zones               = optional(list(string))
    enable_auto_scaling = optional(bool)
    min_count           = optional(number)
    max_count           = optional(number)
    os_disk_size_gb     = optional(number)
    os_disk_type        = optional(string)
  })
}
variable "network_profile" {
  type = object({
    network_plugin = string
    network_policy = optional(string)
  })
  default = { network_plugin = "azure", network_policy = "azure" }
}
variable "app_gateway_id" { type = string; default = null }
variable "enable_key_vault_secrets_provider" { type = bool; default = true }
variable "log_analytics_workspace_id" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
