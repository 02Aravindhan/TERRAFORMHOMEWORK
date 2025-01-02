variable "resource_group" {
    type = string
  
  
}

variable "location" {
  type = string
  
}

variable "vnets" {
  type = map(object({
    vnet_name = string
    address_space = string
  }))
}

variable "subnets" {
    type = map(object({
      subnets_name =string
      address_prefixes=string
    }))
  
}

variable "nsg_name" {
  type  = string
  
}

variable "nsg_security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_ranges     = list(string)
    

  }))
}

variable "route_table" {
  type = string
}