

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
keyvault_name       = "keyvault881881"


# Virtual Machine (VM)
vm_name             = "vm"
//vm_size             = "Standard_DS1_v2"
admin_username      = "project4"
admin_password      = "aravindh88"
os_disk_name        = "vm-os-disk"
//caching                  = "ReadWrite"
//storage_account_type     = "Standard_LRS"



# #encry-disk
  key-name       = "keyvault"
