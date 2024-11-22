

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


# # Virtual Machine (VM)
# vm_name             = "vm"
admin_username      = "azureuser"
admin_password      = "H@llomt15!"
# os_disk_name        = "vm-os-disk"

//stroage_account
storage_account_name = "storageaccountproj4"
//data_disk
managed_disk_name = "Data_disk"

#key
  key-name       = "keyvault"

#user_ass_identity
user_ass_identity_name = "key_user_identity"

//load_balancer
lb_name = "private-lb"

//disk_encryption
disk_encryption_name = "disk_encryption"

