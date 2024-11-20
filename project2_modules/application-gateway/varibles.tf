# Variables for Application Gateway configuration

variable "appgateway_name" {
 
  type        = string
}

variable "location" {
  
  type        = string
}

variable "resource_group_name" {
  
  type        = string
}

variable "sku_name" {
 
  type        = string
}

variable "sku_tier" {
  
  type        = string
}

variable "sku_capacity" {

  type        = number
}

variable "subnet_id" {
  
  type        = string
}

variable "public_ip_address_id" {
  
  type        = string
}

variable "frontend_port_name" {
 
  type        = string
}

variable "frontend_port_value" {
 
  type        = number
}

variable "ssl_certificate_name" {

  type        = string
}

variable "ssl_certificate_key_vault_secret_id" {
 
  type        = string
}

variable "http_listener_name" {
  
  type        = string
}

variable "protocol" {
  
  type        = string
}

variable "cookie_based_affinity" {
  
  type        = string
}

variable "backend_port" {
  
  type        = number
}

variable "backend_protocol" {
  
  type        = string
}

variable "request_timeout" {
  
  type        = number
}

variable "backend_address_pool_name" {

  type        = string
}

variable "request_routing_rule_name" {

  type        = string
}

variable "rule_type" {
  
  type        = string
}
variable "gateway_ip_configuration_name" {
  type = string
}
variable "frontend_ip_configuration" {
 type=string 
}
variable "frontend_ip_configuration_name" {
  type = string
}
variable "name" {
  type = string
}
variable "backend_http_settings_name" {
  type = string
}