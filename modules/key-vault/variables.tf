variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "sku_name" { type = string; default = "premium" }
variable "soft_delete_retention_days" { type = number; default = 90 }
variable "purge_protection_enabled" { type = bool; default = true }
variable "enable_rbac_authorization" { type = bool; default = false }
variable "public_network_access_enabled" { type = bool; default = false }
variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}
variable "access_policies" {
  type = map(object({
    object_id               = string
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    certificate_permissions = optional(list(string))
  }))
  default = {}
}
variable "tags" { type = map(string); default = {} }
