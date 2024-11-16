variable "resource_group_name" {
  type = string
}
variable "location" {
  type    = string
}
variable "lb_name" {
  type = string
}
variable "sku" {
  type = string
}
# variable "internal" {
#   type = bool
# }
variable "frontend_ip_name" {
    type = string
  
}
variable "subnet_id" {
  type = string
}

variable "private_ip_address_allocation" {
  type = string
}