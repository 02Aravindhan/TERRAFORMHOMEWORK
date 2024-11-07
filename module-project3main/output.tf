output "rg" {
    value = module.rg
  
}
output "vnets" {
    value = module.vnets
  
}

output "subnets_name" {
  value = module.subnets
  
}

output "nsg_name" {
  value = module.nsg_name
  
}
output "nsg_rules" {
  value = module.nsg_rules
  
}
output "route_table" {
  value = module.route_table
  
}
output "nsg-subnets-asso" {
  value = module.nsg-t0-subnets-asso
  
}
output "routetable-subnets-asso" {
  value = module.route-to-subnet-associate
  
}
