terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"           
 backend "azurerm" {
    resource_group_name = "RemoteState-rg"
    storage_account_name = "projectstorageaccount11"
    container_name = "storage-backend"
    key = "project2-backend.tfstate"
    
  }
}
 
provider "azurerm" {
    features {}
}
 
 data "azurerm_resource_group" "project6-rg" {
   name = "module2-rg"
  
 }

 data "azurerm_virtual_network" "vnet" {
  name = "modules_vnets"
  resource_group_name =data.azurerm_resource_group.project6-rg.name
  depends_on = [ data.azurerm_resource_group.project6-rg ]
 }
 data "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}
module "firewall_subnet" {
  source = "../project2_modules/subnet"
   for_each       = var.firewall_subnet
  subnets_name    = each.key
  address_prefixes= each.value.address_prefix
  vnet_name    = data.azurerm_virtual_network.vnet.name
  rg_name = data.azurerm_resource_group.project6-rg.name

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet]
}
# Firewall Public IP

module "Public_ip" {
  source            = "../project2_modules/public_ip"
  public_ip_name    = "Firewall-public-IP"
  resource_group_name       = data.azurerm_resource_group.project6-rg.name
  location          = data.azurerm_resource_group.project6-rg.location
  allocation_method = "Static"
  sku               = "Standard"

  depends_on = [data.azurerm_resource_group.project6-rg]
}
// Firewall Policy

module "firewall_policy" {
  source               = "../project2_modules/firewall_policy"
  firewall_policy_name = "firewall-policy"
  resource_name        = data.azurerm_resource_group.project6-rg.name
  location             = data.azurerm_resource_group.project6-rg.location
  sku                  = "Standard"

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}


# #Firewall

module "firewall" {
  source        = "../project2_modules/firewall"
  firewall_name = "firewall"
  resource_group_name = module.firewall_policy.resource_group_name
  location      = module.firewall_policy.location
  sku_name      = "AZFW_VNet"
  sku_tier      = "Standard"

  ip_configuration_name = "firewallconfiguration"
  subnet_id             = module.firewall_subnet["AzureFirewallSubnet"].subnet_id
  public_ip_address_id  = module.Public_ip.public_ip_id

  firewall_policy_id = module.firewall_policy.firewall_policy_id

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet,
  module.Public_ip,module.firewall_policy]
}

// Route Table

module "route_table" {
  source           = "../project2_modules/route _table"
  route_table      = var.route_table_name
  rg_name          = data.azurerm_resource_group.project6-rg.name
  location         = data.azurerm_resource_group.project6-rg.location
  depends_on       = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}

// firewall- Route

module "firewall_route" {
  source                 = "../project2_modules/route"
  route_name             = "route-to-firewall"
  resource_group_name    = module.route_table.resource_group_name
  location               = module.route_table.location
  route_table_name       = module.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.8.4"

  depends_on = [module.firewall, module.route_table]
}
// Associate to routetable

module "routetable-associate" {
  source         = "../project2_modules/routetable-associate"
  subnet_id      = data.azurerm_subnet.subnet["subnet11"].id
  route_table_id = module.route_table.route_table_id

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_subnet.subnet, module.route_table]
}

// nsg

module "nsg" {
  source        = "../project2_modules/nsg"
  nsg_name      = var.nsg_name
  rg_name       = data.azurerm_resource_group.project6-rg.name
  location      = data.azurerm_resource_group.project6-rg.location

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}
module "nsg_rule" {
  source        = "../project2_modules/nsg_rule"
  for_each      = var.security_rules
  nsg_name      = each.key
  rg_name       = data.azurerm_resource_group.project6-rg.name
  location      = data.azurerm_resource_group.project6-rg.location

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_ranges
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  depends_on = [module.nsg]
}
//nsg associate subnet

module "nsg-associate-to-sub" {
  source    = "../project2_modules/nsg-associate"
  subnet_id = data.azurerm_subnet.subnet["subnet11"].id
  network_security_group_id     = module.nsg.network_security_group_id
  depends_on = [data.azurerm_subnet.subnet,module.nsg ]
}
