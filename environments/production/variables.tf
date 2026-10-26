variable "resource_groups" {
  type = map(object({
    location = string
    tags     = map(string)
  }))
}

variable "network_security_groups" {
  type = map(object({
    location           = string
    resource_group_key = string
    security_rules = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
      description                = optional(string)
    }))
    tags = map(string)
  }))
}

variable "virtual_networks" {
  type = map(object({
    location           = string
    resource_group_key = string
    address_space      = list(string)
    dns_servers        = optional(list(string))
    subnets = map(object({
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), [])
      nsg_id            = optional(string)
      delegations = optional(map(object({
        service_name    = string
        service_actions = optional(list(string), [])
      })), {})
    }))
    tags = map(string)
  }))
}

variable "key_vaults" {
  type = map(object({
    location                  = string
    resource_group_key        = string
    sku_name                  = string
    enable_rbac_authorization = bool
    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
    access_policies = optional(map(object({
      object_id               = string
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      certificate_permissions = optional(list(string))
    })), {})
    tags = map(string)
  }))
}
