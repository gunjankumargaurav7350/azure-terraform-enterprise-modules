resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
  tags                = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.autoscale_configuration == null ? var.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.key
      ip_addresses = try(backend_address_pool.value.ip_addresses, null)
      fqdns        = try(backend_address_pool.value.fqdns, null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                  = backend_http_settings.key
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = try(backend_http_settings.value.request_timeout, 20)
      probe_name            = try(backend_http_settings.value.probe_name, null)
      host_name             = try(backend_http_settings.value.host_name, null)
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = "appGatewayFrontendIP"
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = try(http_listener.value.host_name, null)
      ssl_certificate_name           = try(http_listener.value.ssl_certificate_name, null)
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.key
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = try(request_routing_rule.value.backend_address_pool_name, null)
      backend_http_settings_name = try(request_routing_rule.value.backend_http_settings_name, null)
      priority                   = request_routing_rule.value.priority
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name                = probe.key
      protocol            = probe.value.protocol
      path                = probe.value.path
      host                = try(probe.value.host, null)
      interval            = try(probe.value.interval, 30)
      timeout             = try(probe.value.timeout, 30)
      unhealthy_threshold = try(probe.value.unhealthy_threshold, 3)
    }
  }
}
