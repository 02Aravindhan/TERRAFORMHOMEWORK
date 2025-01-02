variable "vnets" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  type = list(string)
}

variable "vnet_name" {
type=string
}
  

variable "subnets_name" {
  type = string
}
 
variable "address_prefixes" {
  type = string
}
 