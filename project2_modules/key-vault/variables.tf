

  variable "name" {
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