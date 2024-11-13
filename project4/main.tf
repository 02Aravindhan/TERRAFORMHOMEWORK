terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"           // Create a Resource Group using Terraform
 
}
 
provider "azurerm" {
    features {}
}
 
 data "azurerm_resource_group" "project4-rg" {
   name = "module2-rg"
  
 }

 data "azurerm_virtual_network" "vnet" {
  name = "modules_vnets"
  resource_group_name ="module2-rg"
 
 }
 module "subnets" {
  source = "../project2_modules/subnet"
  for_each = var.subnets
  subnets_name = each.value.subnets_name
  address_prefixes = each.value.address_prefix
  vnet_name = data.azurerm_virtual_network.vnet.name
  rg_name = data.azurerm_resource_group.project4-rg.name

  depends_on = [ data.azurerm_resource_group.project4-rg,data.azurerm_virtual_network.vnet ]
  
}

 # Network Interface (NIC)
module  "nic" {
  source = "../project2_modules/nic"
  location                  = data.azurerm_resource_group.project4-rg.location
  resource_group_name       = data.azurerm_resource_group.project4-rg.name
  nic_name = var.nic_name
  ip_configuration_name = "internal"
  subnet_id = module.subnets["subnet11"].subnet_id
  private_ip_address_allocation = "Dynamic"
  depends_on = [ data.azurerm_resource_group.project4-rg,module.subnets ]
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}


# key_vault

module "key_vault" {
  source              = "../project2_modules/key-vault"
  name                = var.keyvault_name
  sku_name            = "standard"
  purge_protection_enabled   =true
  soft_delete_retention_days =30 
  secret_permissions = ["Get","Set",]
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  location           = data.azurerm_resource_group.project4-rg.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_client_config.current.object_id
  depends_on = [ data.azurerm_resource_group.project4-rg ]
}

# Key for disk encryption (Customer Managed Key)
module "key_vault_key" {
  source = "../project2_modules/disk_encryption-key"  
  name =   var.keyvault_name
  disk_encryption-key_id = module.key_vault.key_vault_id
  key_opts     = ["encrypt", "decrypt"]
  key_size     =2048                         
  key_type     = "RSA"
  depends_on = [ module.key_vault ]
}


module "project4-vm" {
  source = "../project2_modules/vm"  
  
  vm_name                  = var.vm_name
  location = data.azurerm_resource_group.project4-rg.location
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  vm_size                  = "Standard_DS1_v2"
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  os_disk_name             = var.os_disk_name
  caching                  = "ReadWrite"
  storage_account_type     = "Standard_LRS"
   vm_image_publisher  = "Canonical"
   vm_image_offer      = "Ubuntuserver"
   vm_image_sku        = "18.04-LTS"
   vm_image_version    = "latest" 
  network_interface_ids    = module.nic.nic_id
  disk_encryption_set_id = module.key_vault_key.disk_encryption-key_id
  depends_on = [ data.azurerm_resource_group.project4-rg ,module.nic,module.key_vault_key]
}
