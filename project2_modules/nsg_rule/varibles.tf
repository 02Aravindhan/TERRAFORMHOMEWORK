variable "rg_name" {
    type = string
  
}

variable "nsg_name" {
  
  type        = string
}

variable "location" {
    type = string
  
}
variable "name" {
    type = string
  
}
variable "priority" {
    type = string
  
}
variable "direction" {
    type = string
  
}

variable "access" {
  type = string
}
variable "protocol" {
    type = string
  
}
variable "source_port_range" {
    type = string
  
}
variable "source_address_prefix" {
    type = string
  }
variable "destination_port_range" {
  type =list(string) 
}
     
variable "destination_address_prefix" {
    type = string
  
}