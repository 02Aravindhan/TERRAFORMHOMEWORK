variable "vmss_name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "instances" {
  type = number
}
variable "admin_password" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "identity_type" {
  type = string
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "primary" {
  type = bool
}

variable "ip_configuration_name" {
  type = string
}

variable "subnet_id" {
  type = string
}


variable "os_caching" {
  type = string
}

variable "storage_account_type" {
  type = string
}
variable "application_gateway_backend_address_pool_ids" {
  type = list(string)
}