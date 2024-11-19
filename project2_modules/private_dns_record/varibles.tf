variable "resource_group_name" {
  type = string
}
variable "record_name" {
  type    = string
}
variable "zone_name" {
  type    = string
}
variable "ttl" {
  type    = number
}
variable "records" {
  type    = list(string)
}

