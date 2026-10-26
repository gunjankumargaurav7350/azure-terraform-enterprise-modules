resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = try(each.value.service_endpoints, [])

  dynamic "delegation" {
    for_each = try(each.value.delegations, {})
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.service_name
        actions = try(delegation.value.service_actions, [])
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for k, v in var.subnets : k => v.nsg_id if try(v.nsg_id, null) != null }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}
