resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}

module "network_security_groups" {
  source   = "../../modules/network-security-group"
  for_each = var.network_security_groups

  name                = each.key
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg[each.value.resource_group_key].name
  security_rules      = each.value.security_rules
  tags                = each.value.tags
}

module "virtual_networks" {
  source   = "../../modules/virtual-network"
  for_each = var.virtual_networks

  name                = each.key
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg[each.value.resource_group_key].name
  address_space       = each.value.address_space
  dns_servers         = try(each.value.dns_servers, [])
  subnets             = each.value.subnets
  tags                = each.value.tags

  depends_on = [module.network_security_groups]
}

module "key_vault" {
  source   = "../../modules/key-vault"
  for_each = var.key_vaults

  name                          = each.key
  location                      = each.value.location
  resource_group_name           = azurerm_resource_group.rg[each.value.resource_group_key].name
  sku_name                      = each.value.sku_name
  enable_rbac_authorization     = each.value.enable_rbac_authorization
  public_network_access_enabled = false
  network_acls                  = each.value.network_acls
  access_policies               = each.value.access_policies
  tags                          = each.value.tags
}
