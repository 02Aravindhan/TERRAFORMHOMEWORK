output "module_rg" {
  value =module.name  
  
}
output "vnet_name" {
  value = module.vnets
  
}

output "subnets_name" {
  value = module.subnets
  
}
output "nsg" {
  value = module.nsg
  
}

output "route_table" {
  value = module.route_table
  
}