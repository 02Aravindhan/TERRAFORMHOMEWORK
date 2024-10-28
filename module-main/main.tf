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

module "name" {
  source = "../project2_modules/resource_group"
  rg_name = var.resource_group
  location = var.location
}

module "vnets" {
  source = "../project2_modules/vnets" 

  for_each = var.vnets
  address_space = [each.value.address_space  ]
  vnet_name = each.key
  rg_name = module.name.rg
  location = module.name.location
  
  depends_on = [ module.name ]
}

module "subnets" {
  source = "../project2_modules/subnet"
  for_each = var.subnets
  subnets_name = each.value.subnets_name
  address_prefixes = each.value.address_prefixes
  vnet_name = module.vnets["modules_vnets"].name
  rg_name = module.name.rg

  depends_on = [ module.vnets ]
  
}

module "nsg" {
  source = "../project2_modules/nsg"
  for_each = 

  
}

