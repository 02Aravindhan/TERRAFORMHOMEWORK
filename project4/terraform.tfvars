

subnets = {
  "subnet11" = {
       subnets_name="subnet11"
       address_prefix="10.0.5.0/24"
  },
  "subnet22" = {
       subnets_name="subnet22"
       address_prefix="10.0.6.0/24"
  }
}

# Network Interface (NIC)
nic_name            = "project4-nic"




 # Key Vault
keyvault_name       = "ky1218"
sku_name                    = "standard"              
purge_protection_enabled    = true
soft_delete_retention_days  = 30

# Permissions
secret_permissions          = ["Get",
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

# Key Vault Key
key_name                    = "keyvault"
key_opts                    = ["sign", "verify","encrypt", "decrypt", "unwrapKey",  "wrapKey",]
key_size                    = 2048
key_type                    = "RSA"


# Secret Information
admin_username = "azureuser"
admin_username_value = "adminValue"
admin_password = "Hello"
admin_password_value ="adminPasswordValue123"

# # # Virtual Machine (VM)
# # vm_name             = "vm"
# admin_username      = "azureuser"
# admin_password      = "H@llomt15!"
# # os_disk_name        = "vm-os-disk"

# //stroage_account
# storage_account_name = "storageaccountproj4"
# //data_disk
# managed_disk_name = "Data_disk"

# #key
#   key-name       = "keyvault"

# #user_ass_identity
# user_ass_identity_name = "key_user_identity"



# //disk_encryption
# disk_encryption_name = "disk_encryption"

# //Load Balancer Name
lb_name = "private-lb"
sku = "Standard"

//Frontend IP Configurations
frontend_ip_name = "frontend1"

private_ip_address_allocation = "Dynamic"


# Backend Address Pools

backpool_name = "backend_pool1"
  

# Load Balancing Rules
    lb_rule_name  = "rule1"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    idle_timeout_in_minutes        = 4
    frontend_ip_configuration_name = "frontend1"

  

# Probes
  HealthProbe_name = "Heathprobe1"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2

