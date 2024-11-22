output "gateway" {
  value = module.application_gateway.appgateway
}
output "vmss" {
  value = module.vmss.vmss
}