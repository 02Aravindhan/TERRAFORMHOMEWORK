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
 resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  name =each.key 
  address_prefixes = [each.value.address_prefix]
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
   depends_on = [ data.azurerm_resource_group.project4-rg,data.azurerm_virtual_network.vnet ]
 }

 # Network Interface (NIC)
resource "azurerm_network_interface" "nic" {
  name                      = var.nic_name
  location                  = data.azurerm_virtual_network.vnet.location
  resource_group_name       = data.azurerm_virtual_network.vnet.resource_group_name
  ip_configuration {
    name = "internal"

  
  subnet_id                 = azurerm_subnet.subnets["subnet11"].id
  private_ip_address_allocation = "Dynamic"
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
resource "azurerm_key_vault_key" "key_disk" {
  name         = "keyvault"
  key_vault_id = azurerm_key_vault.Key_vault.id
   key_opts     = ["encrypt", "decrypt"]
   key_size     = 2048
   key_type     = "RSA"
}

# Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "project4_vm" {
  name                = var.vm_name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  location            = data.azurerm_virtual_network.vnet.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    name                     = var.os_disk_name
    caching                  = "ReadWrite"
    storage_account_type     = "Standard_LRS"
    disk_encryption_set_id = azurerm_key_vault_key.key_disk
  }
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = "latest"
  }
  depends_on = [ data.azurerm_resource_group.project4-rg,data.azurerm_virtual_network.vnet ]
}