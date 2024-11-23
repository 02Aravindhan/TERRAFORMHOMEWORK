<!-- BEGIN_TF_DOCS -->


```hcl
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
//nic to associate
module "nic_backend_asso" {
  source = "../project2_modules/nic_associate"
  network_interface_id = module.nic.nic_id
  backend_address_pool_id = module.backend_address_pool.backend_address_pool_id
  ip_configuration_name = "internal"
}
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

//admin_name
module "admin_username" {
  source = "../project2_modules/admin_username"
  admin_username = "project4-name"
  value = var.admin_username
  key_vault_id = module.key_vault.key_vault_id
  depends_on = [ module.key_vault ]
}
//admin_password
module "admin_password" {
  source = "../project2_modules/admin_password"
  admin_password = "project4-password"
  value = var.admin_password
  key_vault_id = module.key_vault.key_vault_id
  depends_on = [ module.key_vault ]
}

# // key_vault

module "key_vault" {
  source              = "../project2_modules/key-vault"
  name          = var.keyvault_name
  sku_name            = "standard"
  purge_protection_enabled   =true
  soft_delete_retention_days =30 
  secret_permissions = ["Get",
      "Set",
      "Backup",
      "Delete",
      "Purge",
      "List",
      "Recover",
      "Restore",]
   certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover"
    ]
  key_permissions = ["Get","List","Create","Delete"]
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  location           = data.azurerm_resource_group.project4-rg.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_client_config.current.object_id
  depends_on = [ data.azurerm_resource_group.project4-rg ]
}

// Key for disk encryption (Customer Managed Key)
module "key_vault_key" {
  source = "../project2_modules/key_vault_key"  
  key_name =   var.keyvault_name
  key_vault_id = module.key_vault.key_vault_id
  key_opts     = ["encrypt", "decrypt"]
  key_size     =2048                         

  key_type     = "RSA"
  depends_on = [ module.key_vault ]
}

module "disk_encryption" {
  source = "../project2_modules/disk_encryption"
  disk_encryption_name = var.disk_encryption_name
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  location = data.azurerm_resource_group.project4-rg.location
  key_vault_key_id = module.key_vault_key.id

  depends_on = [ module.key_vault_key,data.azurerm_resource_group.project4-rg ]
}

//create the manged user identity
module "user_ass_identity" {
  source = "../project2_modules/user_assigned_identity"
  user_ass_identity_name = var.user_ass_identity_name
  resource_group_name =data.azurerm_resource_group.project4-rg.name
  location = data.azurerm_resource_group.project4-rg.location
  depends_on = [ data.azurerm_resource_group.project4-rg,module.key_vault,module.key_vault_key ]
}
//ctreate the key_vault_policy
module "key_vault_policy" {
  source = "../project2_modules/key_vault_policy"
  key_vault_id = module.key_vault.key_vault_id             
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.user_ass_identity.user_ass_identity_id

  
  secret_permissions      = ["Get","List"]           
  key_permissions         = ["Get","List"]
  certificate_permissions = ["Get","List"]
  depends_on = [ module.key_vault,module.user_ass_identity ]
}
//load_balancer
module "private_lb" {
  source = "../project2_modules/LoadBalancer"
  lb_name = var.lb_name
  location = data.azurerm_resource_group.project4-rg.location
  resource_group_name = data.azurerm_resource_group.project4-rg.name
  sku = "Standard"
  subnet_id =  module.subnets["subnet22"].subnet_id
  private_ip_address_allocation = "Dynamic"
  frontend_ip_name = "private-frontend-ip"
  depends_on = [data.azurerm_resource_group.project4-rg ]
}

//backend_pool
module "backend_address_pool" {
  source = "../project2_modules/backend_address_pool"
  backpool_name = "Backendpool"
  loadbalancer_id = module.private_lb.azurerm_lb_id
  depends_on = [ module.private_lb ]
}
//lb_rule
module "lb_rule" {
  source = "../project2_modules/lb_rule"
    lb_rule_name                     ="project4-Rule"
    protocol                         = "Tcp"
    frontend_port                    = 80
    backend_port                     = 80
    frontend_ip_configuration_name   = "private-frontend-ip"
    idle_timeout_in_minutes          = 4
    loadbalancer_id                  = module.private_lb.azurerm_lb_id
    depends_on = [ module.private_lb,module.backend_address_pool ]
}
//lb_healthprobe
module "lb_healthprobe" {
  source = "../project2_modules/lb_healthprobe"
     name                = "HealthProbe"
     protocol            = "Tcp"
     port                = 80
     interval_in_seconds = 5
     number_of_probes    = 2
     loadbalancer_id = module.private_lb.azurerm_lb_id
     depends_on = [ module.private_lb ]

}
module "storage_account" {
  source = "../project2_modules/storage_account"
  storage_account_name = var.storage_account_name
  location = data.azurerm_resource_group.project4-rg.location
  resource_name = data.azurerm_resource_group.project4-rg.name
  account_tier =  "Standard"
  account_replication_type = "LRS"
  depends_on = [ data.azurerm_resource_group.project4-rg ]
}
module "data_disk" {
  source = "../project2_modules/disk"
  managed_disk_name =var.managed_disk_name
  location             = data.azurerm_resource_group.project4-rg.location
  resource_group_name  = data.azurerm_resource_group.project4-rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"
  depends_on = [ data.azurerm_resource_group.project4-rg ]
}
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

```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0.2)

## Resources

The following resources are used by this module:

- [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.project4-rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: n/a

Type: `string`

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: Virtual Machine (VM) variable "vm\_name" { type = string }

Type: `string`

### <a name="input_disk_encryption_name"></a> [disk\_encryption\_name](#input\_disk\_encryption\_name)

Description: disk\_encryption

Type: `string`

### <a name="input_key-name"></a> [key-name](#input\_key-name)

Description: key-disk

Type: `string`

### <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name)

Description: Key Vault

Type: `string`

### <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name)

Description: load\_balance

Type: `string`

### <a name="input_managed_disk_name"></a> [managed\_disk\_name](#input\_managed\_disk\_name)

Description: n/a

Type: `string`

### <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name)

Description: Network Interface (NIC)

Type: `string`

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

Description: storage\_account

Type: `string`

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
      subnets_name =string
      address_prefix=string
    }))
```

### <a name="input_user_ass_identity_name"></a> [user\_ass\_identity\_name](#input\_user\_ass\_identity\_name)

Description: user\_ass\_identit

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_nic"></a> [nic](#output\_nic)

Description: n/a

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_subnet"></a> [subnet](#output\_subnet)

Description: n/a

### <a name="output_vnet"></a> [vnet](#output\_vnet)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_admin_password"></a> [admin\_password](#module\_admin\_password)

Source: ../project2_modules/admin_password

Version:

### <a name="module_admin_username"></a> [admin\_username](#module\_admin\_username)

Source: ../project2_modules/admin_username

Version:

### <a name="module_backend_address_pool"></a> [backend\_address\_pool](#module\_backend\_address\_pool)

Source: ../project2_modules/backend_address_pool

Version:

### <a name="module_data_disk"></a> [data\_disk](#module\_data\_disk)

Source: ../project2_modules/disk

Version:

### <a name="module_disk_encryption"></a> [disk\_encryption](#module\_disk\_encryption)

Source: ../project2_modules/disk_encryption

Version:

### <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault)

Source: ../project2_modules/key-vault

Version:

### <a name="module_key_vault_key"></a> [key\_vault\_key](#module\_key\_vault\_key)

Source: ../project2_modules/key_vault_key

Version:

### <a name="module_key_vault_policy"></a> [key\_vault\_policy](#module\_key\_vault\_policy)

Source: ../project2_modules/key_vault_policy

Version:

### <a name="module_lb_healthprobe"></a> [lb\_healthprobe](#module\_lb\_healthprobe)

Source: ../project2_modules/lb_healthprobe

Version:

### <a name="module_lb_rule"></a> [lb\_rule](#module\_lb\_rule)

Source: ../project2_modules/lb_rule

Version:

### <a name="module_nic"></a> [nic](#module\_nic)

Source: ../project2_modules/nic

Version:

### <a name="module_nic_backend_asso"></a> [nic\_backend\_asso](#module\_nic\_backend\_asso)

Source: ../project2_modules/nic_associate

Version:

### <a name="module_private_lb"></a> [private\_lb](#module\_private\_lb)

Source: ../project2_modules/LoadBalancer

Version:

### <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account)

Source: ../project2_modules/storage_account

Version:

### <a name="module_subnets"></a> [subnets](#module\_subnets)

Source: ../project2_modules/subnet

Version:

### <a name="module_user_ass_identity"></a> [user\_ass\_identity](#module\_user\_ass\_identity)

Source: ../project2_modules/user_assigned_identity

Version:

This is the project4 Configuration Terraform Files.
<!-- END_TF_DOCS -->