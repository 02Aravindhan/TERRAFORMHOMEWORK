
variable "subnets" {
    type = map(object({
      subnets_name =string
      address_prefix=string
    }))
  
}

//Network Interface (NIC)
variable "nic_name" {
 type = string
}


 
// Key Vault
variable "keyvault_name" {
  type = string
}
variable "sku_name" {
  type = string
}

variable "purge_protection_enabled" {
  type        = bool
}

variable "soft_delete_retention_days" {
  type        = number
}
variable "secret_permissions" {
  type        = list(string)
}

variable "certificate_permissions" {
  type        = list(string)
}

variable "key_permissions" {
  type        = list(string)
}
variable "key_name" {
  description = "The name of the Key Vault key."
  type        = string
}

variable "key_opts" {
  description = "Options for the Key Vault key."
  type        = list(string)
}

variable "key_size" {
  
  type        = number
}

variable "key_type" {
  type        = string
}




variable "admin_username" {
  type        = string
}

variable "admin_username_value" {
  type        = string
}

variable "admin_password" {
  type        = string
}

variable "admin_password_value" {
  type        = string
}


# //Virtual Machine (VM)
# # variable "vm_name" {
# #  type = string
# # }
# variable "admin_username" {
#  type = string
# }

# variable "admin_password" {
#   type = string
# }

# # variable "os_disk_name" {
# # type = string
# # }

# //storage_account
# variable "storage_account_name" {
#   type = string
# }

# variable "managed_disk_name" {
#   type = string
# }


# //key-disk
# variable "key-name" {
#     type = string
  
# }

# //disk_encryption
# variable "disk_encryption_name" {
#      type = string
# }



# //user_ass_identit
#  variable "user_ass_identity_name" {
#    type = string
#  }

//load_balance
variable "lb_name" {
  type = string
}

variable "sku" {
  type        = string
  
}


variable "frontend_ip_name" {
  type        = string
}


variable "private_ip_address_allocation" {
  type        = string
}

variable "backpool_name" {
  type        = string
}

variable "lb_rule_name" {
  type        = string
}

variable "protocol" {
  type        = string
}

variable "frontend_port" {
  type        = number
}

variable "backend_port" {
  type        = number
}

variable "frontend_ip_configuration_name" {

  type        = string
}

variable "idle_timeout_in_minutes" {
 
  type        = number
}

variable "HealthProbe_name" {
  type        = string
}

variable "port" {
  type        = number
}

variable "interval_in_seconds" {
 
  type        = number
}

variable "number_of_probes" {
  
  type        = number
}