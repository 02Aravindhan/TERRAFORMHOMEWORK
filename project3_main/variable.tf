variable "resource_group_name" {
    type = string
  
  
}

variable "location" {
  type = string
  
}



variable "vnets" {
  type = map(object({
    vnet_name = string
    address_space = string
 
    subnets=list(object({
      subnets_name =string
      address_prefixes=list(string)
    }))
      }))
}

variable "nsg_name" {
  type  = map(object({
    name = string
  }))
  
}

variable "nsg_con" {
  type = map(object({
    nsg_name    =string
    nsg_security_rules=list(object({
      
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
  }))
}

# variable "route_table" {
#   type = map(object({
#     name=string
#   }))
# }

# variable "nsg-to-subnets-associate" {
#   type = map(object({
#     subnets_name=string
#     nsg_name=string
    
#   }))
  
# }
# variable "route-to-subnets-associate" {
#   type = map(object({
#     subnets_name=string
    
 
#   }))
  
# }