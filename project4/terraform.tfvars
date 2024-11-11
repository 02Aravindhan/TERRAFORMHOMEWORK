

subnets = {
  "subnet1" = {
       subnets_name="subnet11"
       address_prefix="10.0.5.0/24"
  },
  "subnet2" = {
       subnets_name="subnet22"
       address_prefix="10.0.6.0/24"
  }
}
# Network Interface (NIC)
nic_name            = "project4-nic"

ip_configuration = {
  name = "internal"
  private_ip_address_allocation = "Dynamic"
}


# Key Vault
keyvault_name       = "keyvault88"

# Virtual Machine (VM)
vm_name             = "vm"
vm_size             = "Standard_DS1_v2"
admin_username      = "project4"
admin_password      = "aravindh88"
os_disk_name        = "vm-os-disk"
caching                  = "ReadWrite"
storage_account_type     = "Standard_LRS"

# VM Image details (Ubuntu in this case)
vm_image_publisher  = "Canonical"
vm_image_offer      = "UbuntuServer"
vm_image_sku        = "18.04-LTS"
version  = "latest"

#encry-disk
 name         = "keyvault"
   key_opts     = ["encrypt", "decrypt"]
   key_size     = 2048
   key_type     = "RSA"