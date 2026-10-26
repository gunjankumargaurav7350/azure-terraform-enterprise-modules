resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    zones               = try(var.default_node_pool.zones, ["1", "2", "3"])
    enable_auto_scaling = try(var.default_node_pool.enable_auto_scaling, true)
    min_count           = try(var.default_node_pool.min_count, 2)
    max_count           = try(var.default_node_pool.max_count, 10)
    os_disk_size_gb     = try(var.default_node_pool.os_disk_size_gb, 128)
    os_disk_type        = try(var.default_node_pool.os_disk_type, "Managed")
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_profile.network_plugin
    network_policy    = try(var.network_profile.network_policy, "azure")
    load_balancer_sku = "standard"
  }

  dynamic "ingress_application_gateway" {
    for_each = var.app_gateway_id != null ? [1] : []
    content {
      gateway_id = var.app_gateway_id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_key_vault_secrets_provider ? [1] : []
    content {
      secret_rotation_enabled = true
    }
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  tags = var.tags
}
