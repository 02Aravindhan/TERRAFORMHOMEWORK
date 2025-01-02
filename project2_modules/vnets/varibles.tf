variable "rg_name" {
  type = string
  
}

variable "location" {
  description = "The Azure location for the resources"
  type        = string
  
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)

}


