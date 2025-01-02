

variable "lb_name" {
  
  type        = string
}

variable "location" {
 
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "sku" {
  type        = string
  
}

variable "frontend_ip_name" {
    type = string
  
}
variable "subnet_id" {
  type = string
}

variable "private_ip_address_allocation" {
  type = string
}

variable "backpool_name" {
  type = string
}
variable "lb_rule_name" {
  type = string
}
variable "protocol" {
  type = string
}
variable "frontend_port" {
  type = string
}
variable "backend_port" {
  type = string
}
variable "idle_timeout_in_minutes" {
  type = string
}
variable "frontend_ip_configuration_name" {
  type = string
}

variable "HealthProbe_name" {
  type = string
}

variable "port" {
  type = string
}
variable "interval_in_seconds" {
  type = string
}
variable "number_of_probes" {
  type = string
}