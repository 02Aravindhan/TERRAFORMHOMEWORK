

  variable "key_vault_name" {
    type = string
    
  }
  variable "resource_group_name" {
    type = string
    
  }
  variable "location" {
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
        type = list(string)
        }


variable "tenant_id" {
  type = string
}
variable "object_id" {
    type = string
  
}
variable "key_permissions" {
  type =list(string)
}
variable "certificate_permissions" {
  type = list(string)
}

//key
variable "key_name" {
    type = string
  
}

variable "key_opts" {
  type = list(string)
}
variable "key_size" {
  type = string
}
variable "key_type" {
    type = string
  
}

//secret
variable "admin_username_value" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password_value" {
  type = string
}
variable "admin_password" {
  type = string
}