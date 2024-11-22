variable "vmss_name" {
  type = string
}
variable "subnets" {
    type = map(object({
      subnets_name =string
      address_prefix=string
    }))
  
}


variable "admin_username" {
 type = string
}

variable "admin_password" {
  type = string
}
