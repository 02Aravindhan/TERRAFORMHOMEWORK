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
 
 data "azurerm_resource_group" "project5-rg" {
   name = "module2-rg"
  
 }

 data "azurerm_virtual_network" "vnet" {
  name = "modules_vnets"
  resource_group_name ="module2-rg"
  depends_on = [ data.azurerm_resource_group.project5-rg ]
 }

 data "azurerm_subnet" "subnet22" {
   name = "subnet22"
   resource_group_name ="module2-rg"
   virtual_network_name = "modules_vnets"
   depends_on = [ data.azurerm_resource_group.project5-rg,data.azurerm_virtual_network.vnet ]
 }
 data "azurerm_key_vault" "Key_vault" {
   name = "ky678"
   resource_group_name = data.azurerm_resource_group.project5-rg.name
 }

 data "azurerm_key_vault_secret" "admin_username"  {
   name ="project4-name"
   key_vault_id = data.azurerm_key_vault.Key_vault.id
 }
 data "azurerm_key_vault_secret" "admin_password" {
   name ="project4-password"
   key_vault_id = data.azurerm_key_vault.Key_vault.id
 }
 module "vmss" {
   source = "../project2_modules/vmss"
   vmss_name = var.vmss_name
  location                        = data.azurerm_resource_group.project5-rg.location
  resource_group_name             = data.azurerm_resource_group.project5-rg.name
  sku                             = "Standard_D2_v3"
  instances                       = 2
  upgrade_mode                    = "Automatic"
  admin_username                  = 
  admin_password                  = 
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name                       = "nic"
    primary                    = true
    enable_accelerated_networking = false
  }
  ip_configuration {
       name = var.name
       subnet_id = 
      
    } 

  identity {
    type = "UserAssigned"
  }
}
 