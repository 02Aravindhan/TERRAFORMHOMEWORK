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
  address_prefixes = each.value.address_prefixes
  vnet_name = data.azurerm_virtual_network.vnet.name
  rg_name = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [ data.azurerm_virtual_network.vnet ]
  
}

 # Network Interface (NIC)
module  "nic" {
  source = "../project2_modules/nic"
  name                      = var.nic_name
  location                  = data.azurerm_virtual_network.vnet.location
  resource_group_name       = data.azurerm_virtual_network.vnet.resource_group_name

  ip_configuration {
    name =var.name
   subnet_id                 = azurerm_subnet.subnets["subnet11"].id
  private_ip_address_allocation = var.private_ip_address_allocation
  }
  
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}


# key_vault
resource "azurerm_key_vault" "Key_vault" {
  name                        = var.keyvault_name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  location = data.azurerm_virtual_network.vnet.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  soft_delete_retention_days = 30
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_client_config.current.object_id
 
    secret_permissions = [
      "Get",
      "Set",
    ]
  }
  depends_on = [ data.azurerm_virtual_network.vnet ]
}

# Key for disk encryption (Customer Managed Key)
module "key_vault_key" {
  source = "../project2_modules/disk_encryption-key"  
  name = var.name
  key_vault_id = azurerm_key_vault.Key_vault.id  
  # key_name     = var.key_name
  key_opts     = var.key_opts
  key_size     = var.key_size                         
  key_type     = var.key_type
}


module "project4-vm" {
  source = "../project2_modules/vm"  # Adjust path to your module
  
  vm_name                  = var.vm_name
  location = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  vm_size                  = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  os_disk_name             = var.os_disk_name
  caching                  = var.caching
  storage_account_type     = var.storage_account_type
  vm_image_publisher       = var.vm_image_publisher
  vm_image_offer           = var.vm_image_offer
  vm_image_sku             = var.vm_image_sku
  version                  = var.version
  network_interface_ids    = [azurerm_network_interface.nic.id]  # Pass NIC ID from the NIC module
 // key_vault_key_id         = azurerm_key_vault_key.key_vault_key_id  # Pass key vault key ID
  disk_encryption_set_id = azurerm_key_vault_key.key_disk
  depends_on = [ data.azurerm_resource_group.project4-rg ]
}
