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
 module "ssl_certificate" {
  source = "../project2_modules/ssl_certificate"

  ssl_name               ="ssl-certificate"
  key_vault_id           = data.azurerm_key_vault.Key_vault.id
  issuer_parameters_name = "Self"
  exportable             = true
  key_size               = 2048
  key_type               = "RSA"
  reuse_key             = true
  action_type           = "AutoRenew"
  days_before_expiry    = 30
  content_type          = "application/x-pkcs12"
  extended_key_usage    = ["1.3.6.1.5.5.7.3.1"]
  key_usage             = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
  dns_names             = ["internal.contoso.com", "domain.hello.world"]
  subject               =  "CN=hello-world"
  validity_in_months    = 12
  depends_on = [ data.azurerm_key_vault.Key_vault ]
}
# Create Private DNS Zone for Key Vault
module "private_dns_zone" {
  source = "../project2_modules/private_dns_zone"
  dns_names ="private.dns.zone"
  resource_group_name = data.azurerm_resource_group.project5-rg.name 
  depends_on = [ data.azurerm_key_vault.Key_vault ]
}
# Link the DNS Zone to the VNet
module "private_dns_zone_vnet_link" {
  source = "../project2_modules/private_dns_zone_vnet_link"
  private_dns_zone_vnet_link_name = "private-vnet-link"
  private_dns_zone_name =module.private_dns_zone.private_dns_zone_name
  resource_group_name =data.azurerm_resource_group.project5-rg.name
  virtual_network_id =data.azurerm_virtual_network.vnet.id
  registration_enabled =true 
  depends_on = [ data.azurerm_resource_group.project5-rg,data.azurerm_virtual_network.vnet,module.private_dns_zone ]
}
module "private_endpoint" {
  source = "../project2_modules/private_endpoint"
  private_endpoint_name =          "keyvault-private-endpoint"
  resource_group_name = data.azurerm_resource_group.project5-rg.name
  location            = data.azurerm_resource_group.project5-rg.location
  subnet_id           = data.azurerm_subnet.subnet22.id
  
    name                          = "keyvault-connection"
    private_connection_resource_id = data.azurerm_key_vault.Key_vault.id
    is_manual_connection           = false
    suresource_names = [ "vault" ]
    depends_on = [ data.azurerm_key_vault.Key_vault ,module.private_dns_zone,module.private_dns_zone_vnet_link]
  }

  #dns_record
  module "private_dns_record" {
    source = "../project2_modules/private_dns_record"
    record_name = "dns-record"
    zone_name ="private.dns.zone"
    resource_group_name = data.azurerm_resource_group.project5-rg.name
    ttl                 = 60
    records             = [module.private_endpoint.private_ip_address]
    depends_on = [ module.private_dns_zone,module.private_endpoint,data.azurerm_resource_group.project5-rg ]
  }

#  module "vmss" {
#    source = "../project2_modules/vmss"
#    vmss_name = var.vmss_name
#   location                        = data.azurerm_resource_group.project5-rg.location
#   resource_group_name             = data.azurerm_resource_group.project5-rg.name
#   sku                             = "Standard_D2_v3"
#   instances                       = 2
#   upgrade_mode                    = "Automatic"
#   admin_username                  = 
#   admin_password                  = 
#   os_disk {
#     caching = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   network_interface {
#     name                       = "nic"
#     primary                    = true
#     enable_accelerated_networking = false
#   }
#   ip_configuration {
#        name = var.name
#        subnet_id = 
      
#     } 

#   identity {
#     type = "UserAssigned"
#   }
# }
 