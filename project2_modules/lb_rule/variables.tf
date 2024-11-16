variable "lb_rule_name" {
  type = string
}
variable "protocol" {
  type = string
}
variable "frontend_port" {
  type = string
}
variable "backend_port" {
  type = string
}
variable "idle_timeout_in_minutes" {
  type = string
}
variable "loadbalancer_id" {
  type = string
}
variable "frontend_ip_configuration_name" {
  type = string
}