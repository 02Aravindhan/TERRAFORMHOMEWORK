
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


 
# Key Vault
variable "keyvault_name" {
  type = string
}
variable "sku_name" {
  type = string
}
variable "purge_protection_enabled" {
  type = string
}
variable "soft_delete_retention_days" {
  type = string
}
variable "secret_permissions" {
  type = string
}

# Virtual Machine (VM)
variable "vm_name" {
 type = string
}

variable "vm_size" {
type = string
}

variable "admin_username" {
 type = string
}

variable "admin_password" {
  type = string
}

variable "os_disk_name" {
type = string
}
variable "caching" {
  type = string
}
variable "storage_account_type" {
  type = string
}



//encrytion-disk
variable "key-name" {
    type = string
  
}


# variable "key_opts" {
#   type        = string
  
# }
# variable "key_size" {
#   type = string
# }
# variable "key_type" {
#     type = string
  
# }

