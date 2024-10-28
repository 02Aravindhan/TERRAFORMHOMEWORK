terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "rg" {
  source = "../project3_modules/resource_group"
  rg_name = var.resource_group
  location = var.location
}
module "vnets" {
  source = "../project3_modules/vnets" 

  for_each = var.vnets
  address_space = [each.value.address_space  ]
  vnet_name = each.key
  rg_name = module.rg.rg
  location = module.rg.location
  
  depends_on = [ module.rg ]
}

module "subnets" {
  source = "../project3_modules/subnet"
  for_each = var.subnets
  subnets_name = each.value.subnets_name
  address_prefixes = each.value.address_prefixes
  vnet_name = module.vnets["modules_vnets"].name
  rg_name = module.rg.rg

  depends_on = [ module.vnets ]
  
}
module "nsg_name" {
  source = "../project3_modules/nsg"
  for_each = var.nsg_name
  nsg_name = each.value.name
  rg_name =module.rg.rg 
  location = module.rg.location
  
}
# module "nsg_rules" {
#   source = "../project3_modules/nsg_rule"
#   for_each = var.nsg_rules
#   nsg_name = module.each.key
#   rg_name = module.rg.rg
#   location = module.rg.location
#   name                        = each.value.name
#   priority                    = each.value.priority
#   direction                   = each.value.direction
#   access                      = each.value.access
#   protocol                    = each.value.protocol
#   source_address_prefix       = each.value.source_address_prefix
#   source_port_range           = each.value.source_port_range
#   destination_address_prefix  = each.value.destination_address_prefix
#   destination_port_range      = each.value.destination_port_range
    
#     depends_on = [ module.rg,module.nsg_name ]
#   }

  module "route_table" {
    source = "../project3_modules/routestable"
    for_each = var.route_table
    route_table = each.key
    rg_name = module.rg.rg
    location = module.rg.location
    
  }




