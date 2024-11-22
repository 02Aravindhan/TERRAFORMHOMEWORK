# variable "vmss_name" {
#   type = string
# }
variable "subnets" {
    type = map(object({
      subnets_name =string
      address_prefix=string
    }))
  
}


# //user_ass_identit
#  variable "user_ass_identity_name" {
#    type = string
#  }