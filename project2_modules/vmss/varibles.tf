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
variable "upgrade_mode" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type = string
}
variable "os_disk" {
  type = string
}
variable "caching" {
  type = string
}
variable "storage_account_type" {
  type = string
}
variable "network_interface" {
  type = string
}
variable "name" {
  type = string
}
variable "primary" {
  type = bool
}
variable "enable_accelerated_networking" {
  type = bool
}
variable "identity" {
  type = string
}
variable "type" {
  type = string
}
variable "ip_configuration" {
  type = string
}
variable "name" {
  type = string
}
