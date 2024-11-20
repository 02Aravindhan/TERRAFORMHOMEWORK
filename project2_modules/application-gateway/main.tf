resource "azurerm_application_gateway" "appgateway" {
  name                = var.appgateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name     = var.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                    = var.frontend_ip_configuration
    public_ip_address_id     = var.public_ip_address_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port_value
  }

  ssl_certificate {
    name                 = var.ssl_certificate_name
    key_vault_secret_id  = var.ssl_certificate_key_vault_secret_id
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = var.protocol
    ssl_certificate_name           = var.ssl_certificate_name
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                    = var.name
    cookie_based_affinity    = var.cookie_based_affinity
    port                    = var.backend_port
    protocol                = var.backend_protocol
    request_timeout         = var.request_timeout
  }

  request_routing_rule {
    name                        = var.request_routing_rule_name
    rule_type                   = var.rule_type
    http_listener_name          = var.http_listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }
}
