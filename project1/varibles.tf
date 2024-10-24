variable "rg_name" {
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
      address_prefix=string
    }))
  
}
