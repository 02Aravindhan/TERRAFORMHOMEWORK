
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

# VM Image details (Ubuntu in this case)
variable "vm_image_publisher" {
 type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}