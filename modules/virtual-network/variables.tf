variable "name" {
  description = "Virtual Network Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "address_space" {
  description = "CIDR block for the VNet"
  type        = list(string)
}

variable "dns_servers" {
  description = "List of custom DNS servers"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Map of subnets with address prefixes, service endpoints, and delegations"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    nsg_id            = optional(string)
    delegations = optional(map(object({
      service_name    = string
      service_actions = optional(list(string), [])
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Resource Tags"
  type        = map(string)
  default     = {}
}
