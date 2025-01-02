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
    key = "project4-backend.tfstate"
    
  }
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

  depends_on = [ data.azurerm_resource_group.project4-rg]
  
}


module "loadbalancer" {
  source                = "../project2_modules/private-loadbalance"
  lb_name              = "my-private-lb"
  location            = data.azurerm_resource_group.project4-rg.location
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  sku                 = var.sku
  frontend_ip_name    = var.frontend_ip_name
  subnet_id           = module.subnets["subnet22"].subnet_id
  private_ip_address_allocation = var.private_ip_address_allocation
  backpool_name       = var.backpool_name
  lb_rule_name        = var.lb_rule_name
  protocol            = var.protocol
  frontend_port       = var.frontend_port
  backend_port        = var.backend_port
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  HealthProbe_name =var.HealthProbe_name
  port                = var.port
  interval_in_seconds = var.interval_in_seconds
  number_of_probes    = var.number_of_probes
  
  depends_on = [ data.azurerm_resource_group.project4-rg,module.subnets ]
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
# //nic to associate
# module "nic_backend_asso" {
#   source = "../project2_modules/nic_associate"
#   network_interface_id = module.nic.nic_id
#   backend_address_pool_id =
#   ip_configuration_name = "internal"
# }
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# //admin_name
# module "admin_username" {
#   source = "../project2_modules/admin_username"
#   admin_username = "project4-name"
#   value = var.admin_username
#   key_vault_id = module.key_vault.key_vault_id
#   depends_on = [ module.key_vault ]
# }
# //admin_password
# module "admin_password" {
#   source = "../project2_modules/admin_password"
#   admin_password = "project4-password"
#   value = var.admin_password
#   key_vault_id = module.key_vault.key_vault_id
#   depends_on = [ module.key_vault ]
# }

module "key_vault" {
  source = "../project2_modules/key-vault"
  key_vault_name          = var.keyvault_name
  resource_group_name     = data.azurerm_resource_group.project4-rg.name
  location                = data.azurerm_resource_group.project4-rg.location
  sku_name                = var.sku_name
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               =  data.azuread_client_config.current.object_id
  purge_protection_enabled = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  secret_permissions      = var.secret_permissions
  certificate_permissions = var.certificate_permissions
  key_permissions         =var.key_permissions
  key_name                = var.key_name
  key_opts                = var.key_opts
  key_size                = var.key_size
  key_type                = var.key_type
  admin_password = var.admin_password
  admin_password_value =var.admin_password_value
  admin_username = var.admin_username
  admin_username_value =  var.admin_username_value

  depends_on = [ data.azurerm_resource_group.project4-rg ]
}



#  module "disk_encryption" {
#   source = "../project2_modules/disk_encryption"
#   disk_encryption_name = var.disk_encryption_name
#   resource_group_name = data.azurerm_resource_group.project4-rg.name
#   location = data.azurerm_resource_group.project4-rg.location
#   key_vault_key_id = module.key_vault.key_vault_id

#   depends_on = [ module.key_vault,data.azurerm_resource_group.project4-rg ]
# }

# //create the manged user identity
# module "user_ass_identity" {
#   source = "../project2_modules/user_assigned_identity"
#   user_ass_identity_name = var.user_ass_identity_name
#   resource_group_name =data.azurerm_resource_group.project4-rg.name
#   location = data.azurerm_resource_group.project4-rg.location
#   depends_on = [module.key_vault,data.azurerm_resource_group.project4-rg ]
# }




# module "storage_account" {
#   source = "../project2_modules/storage_account"
#   storage_account_name = var.storage_account_name
#   location = data.azurerm_resource_group.project4-rg.location
#   resource_name = data.azurerm_resource_group.project4-rg.name
#   account_tier =  "Standard"
#   account_replication_type = "LRS"
#   depends_on = [ data.azurerm_resource_group.project4-rg ]
# }
# module "data_disk" {
#   source = "../project2_modules/disk"
#   managed_disk_name =var.managed_disk_name
#   location             = data.azurerm_resource_group.project4-rg.location
#   resource_group_name  = data.azurerm_resource_group.project4-rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "4"
#   depends_on = [ data.azurerm_resource_group.project4-rg ]
# }
# Attach the data disk to the virtual machine
# module "disk_attach" {
#   source = "../project2_modules/data_disk_attachment"
#   managed_disk_id    = module.data_disk.Managed_disk_id
#   virtual_machine_id = module.project4_vm
#   lun                = 0
#   caching            = "ReadWrite"
# }

# module "project4_vm" {
#   source = "../project2_modules/vm"
#   vm_name =var.vm_name
#   resource_group_name =data.azurerm_resource_group.project4-rg.name
#   location =data.azurerm_resource_group.project4-rg.location 
#   vm_size = "Standard_D2s_V3"
#   admin_username = var.admin_username
#   admin_password = var.admin_password
#   network_interface_ids =[module.nic.nic_id]
#   storage_account_type = "Premium_LRS"  
#   caching ="ReadWrite"
#   os_disk_name =var.os_disk_name   
#   disk_encryption_set_id = module.disk_encryption.id
#   vm_image_offer = "windowsServer"
#   vm_image_publisher ="MicrosoftWindowsServer"
#   vm_image_sku ="2022-datacenter-azure-edition"
#   vm_image_version ="latest"
  
#   depends_on = [ data.azurerm_resource_group.project4-rg,module.nic,module.disk_encryption ] 
# }

