

variable "location" {
    type = string
  
}
variable "resource_group_name" {
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

# VM Image details 
variable "vm_image_publisher" {
 type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}
variable "network_interface_ids" {
  type = string
}
variable "caching" {
  type = string
}
variable "storage_account_type" {
  type = string
}

variable "vm_image_version" {
    type = string
  
}
variable "disk_encryption_set_id" {
  type = string
}


