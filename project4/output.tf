output "rg" {
  value = data.azurerm_resource_group.project4-rg
}
output "vnets" {
  value = data.azurerm_virtual_network.vnet.vnet_peerings
}
output "subnet" {
  value = module.subnets
}
output "nic" {
  value = module.nic
}

# output "RemoteState" {
#   value = data.terraform_remote_state.project4.outputs
# }

