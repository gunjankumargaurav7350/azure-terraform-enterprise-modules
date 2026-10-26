variable "name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "Azure region where the NSG will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "security_rules" {
  description = "Map of security rule objects containing rule definitions"
  type = map(object({
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    description                  = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
