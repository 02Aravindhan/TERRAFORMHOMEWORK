
variable "subnets" {
    type = map(object({
      subnets_name =string
      address_prefix=string
    }))
  
}
# Network Interface (NIC)
variable "nic_name" {
 type = string
}


 
// Key Vault
variable "keyvault_name" {
  type = string
}


//Virtual Machine (VM)
# variable "vm_name" {
#  type = string
# }
# variable "admin_username" {
#  type = string
# }

# variable "admin_password" {
#   type = string
# }

# variable "os_disk_name" {
# type = string
# }

//storage_account
variable "storage_account_name" {
  type = string
}

variable "managed_disk_name" {
  type = string
}


//key-disk
variable "key-name" {
    type = string
  
}

//disk_encryption
variable "disk_encryption_name" {
     type = string
}



//user_ass_identit
 variable "user_ass_identity_name" {
   type = string
 }

//load_balance
variable "lb_name" {
  type = string
}
