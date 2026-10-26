variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "sku_name" { type = string; default = "WAF_v2" }
variable "sku_tier" { type = string; default = "WAF_v2" }
variable "capacity" { type = number; default = 2 }
variable "zones" { type = list(string); default = ["1", "2", "3"] }
variable "autoscale_configuration" {
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = { min_capacity = 2, max_capacity = 10 }
}
variable "frontend_ports" { type = map(number); default = { "http-port" = 80, "https-port" = 443 } }
variable "backend_address_pools" {
  type = map(object({
    ip_addresses = optional(list(string))
    fqdns        = optional(list(string))
  }))
  default = {}
}
variable "backend_http_settings" {
  type = map(object({
    cookie_based_affinity = string
    port                  = number
    protocol              = string
    request_timeout       = optional(number, 20)
    probe_name            = optional(string)
    host_name             = optional(string)
  }))
  default = {}
}
variable "http_listeners" {
  type = map(object({
    frontend_port_name   = string
    protocol             = string
    host_name            = optional(string)
    ssl_certificate_name = optional(string)
  }))
  default = {}
}
variable "request_routing_rule" {
  type = map(object({
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = optional(string)
    backend_http_settings_name = optional(string)
    priority                   = number
  }))
  default = {}
}
variable "probes" {
  type = map(object({
    protocol            = string
    path                = string
    host                = optional(string)
    interval            = optional(number, 30)
    timeout             = optional(number, 30)
    unhealthy_threshold = optional(number, 3)
  }))
  default = {}
}
variable "tags" { type = map(string); default = {} }
