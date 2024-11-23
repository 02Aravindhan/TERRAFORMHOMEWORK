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
 
 data "azurerm_resource_group" "project5-rg" {
   name = "module2-rg"
  
 }

 data "azurerm_virtual_network" "vnet" {
  name = "modules_vnets"
  resource_group_name =data.azurerm_resource_group.project5-rg.name
  depends_on = [ data.azurerm_resource_group.project5-rg ]
 }

 data "azurerm_subnet" "subnet22" {
   name = "subnet22"
   resource_group_name =data.azurerm_resource_group.project5-rg.name
   virtual_network_name = data.azurerm_virtual_network.vnet.name
   depends_on = [ data.azurerm_resource_group.project5-rg,data.azurerm_virtual_network.vnet ]
 }
 module "appgateway_subnet" {
   source = "../project2_modules/subnet"
   for_each = var.subnets
   subnets_name = each.key
   rg_name = data.azurerm_resource_group.project5-rg.name
   vnet_name =data.azurerm_virtual_network.vnet.name
   address_prefixes =  each.value.address_prefix
   depends_on = [ data.azurerm_resource_group.project5-rg,data.azurerm_virtual_network.vnet ]
 }
 data "azurerm_key_vault" "Key_vault" {
   name = "ky1218"
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


//Public IP Address for Application Gateway

module "public_ip" {
  source = "../project2_modules/public_ip"
  public_ip_name ="publicip-app-gateway"
  location = data.azurerm_resource_group.project5-rg.location
  resource_group_name =data.azurerm_resource_group.project5-rg.name 
  allocation_method = "Static"
  sku =  "Standard"
  depends_on = [ data.azurerm_resource_group.project5-rg ]
}
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
//create the manged user identity
data  "azurerm_user_assigned_identity" "user_ass_identity" {
  name = "key_user_identity"
  resource_group_name = data.azurerm_resource_group.project5-rg.name
}

//ctreate the key_vault_policy
# module "key_vault_access_policy" {
#   source = "../project2_modules/key_vault_policy"
#   key_vault_id = data.azurerm_key_vault.Key_vault.id             
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_user_assigned_identity.user_ass_identity.principal_id

  
#   secret_permissions      = ["Get","List"]           
#   key_permissions         = ["Get","List"]
#   certificate_permissions = ["Get","List"]
#   depends_on = [ data.azurerm_key_vault.Key_vault,data.azurerm_user_assigned_identity.user_ass_identity]
# }

//application_gateway
module "application_gateway" {
  source                = "../project2_modules/application-gateway"
  appgateway_name       = "application_gateway"
  location              = data.azurerm_resource_group.project5-rg.location
  resource_group_name   = data.azurerm_resource_group.project5-rg.name
  sku_name              = "Standard_v2"
  sku_tier              = "Standard_v2"
  sku_capacity          = 2
  
  type =  "UserAssigned"
  identity_ids = [data.azurerm_user_assigned_identity.user_ass_identity.id]

  gateway_ip_configuration_name = "appGatewayIpConfig"
  subnet_id             = module.appgateway_subnet["appgateway_subnet"].subnet_id

  frontend_ip_configuration_name = "appGatewayFrontendIP"
  public_ip_address_id  = module.public_ip.public_ip_id

  frontend_port_name    = "appGatewayFrontendPort"
  frontend_port_value   = 443
  protocol              = "Https"

  frontend_ip_configuration = "appGatewayFrontendIP"
  name = "appGatewayBackendHttpSettings"
  ssl_certificate_name  = "examplecert"
  ssl_certificate_key_vault_secret_id = module.ssl_certificate.secret_id
  http_listener_name    = "appGatewayListener"

 
  backend_address_pool_name = "appGatewayBackendPool"
  backend_http_settings_name = "appGatewayBackendHttpSettings"
  cookie_based_affinity = "Disabled"
  backend_port          = 80
  backend_protocol      = "Http"
  request_timeout       = 20
  request_routing_rule_name = "appGatewayRule"
  rule_type             = "Basic"
  depends_on = [ data.azurerm_resource_group.project5-rg,module.public_ip,module.ssl_certificate,module.public_ip ]
}




module "vmss" {
  source = "../project2_modules/vmss"

  vmss_name               = var.vmss_name
  location                = data.azurerm_resource_group.project5-rg.location
  resource_group_name     = data.azurerm_resource_group.project5-rg.name
  sku                     = "Standard_DS1_v2"
  instances               = 2
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  os_caching              = "ReadWrite"
  storage_account_type    = "Standard_LRS"
  nic_name                = "nic"
  primary                 =true
  ip_configuration_name   = "internal"
  application_gateway_backend_address_pool_ids=[local.application_gateway_backend_address_pool_ids[0]]
  subnet_id               = data.azurerm_subnet.subnet22.id
  identity_type           = "SystemAssigned"
  image_publisher         = "MicrosoftWindowsServer"
  image_offer             = "WindowsServer"
  image_sku               = "2019-Datacenter"
  image_version           = "latest"
  
  depends_on = [ data.azurerm_resource_group.project5-rg,data.azurerm_subnet.subnet22 ]
}

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
- [azurerm_key_vault.Key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) (data source)
- [azurerm_key_vault_secret.admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) (data source)
- [azurerm_key_vault_secret.admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) (data source)
- [azurerm_resource_group.project5-rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_subnet.subnet22](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) (data source)
- [azurerm_user_assigned_identity.user_ass_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) (data source)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: n/a

Type: `string`

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: n/a

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

### <a name="input_vmss_name"></a> [vmss\_name](#input\_vmss\_name)

Description: n/a

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_gateway"></a> [gateway](#output\_gateway)

Description: n/a

### <a name="output_vmss"></a> [vmss](#output\_vmss)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_appgateway_subnet"></a> [appgateway\_subnet](#module\_appgateway\_subnet)

Source: ../project2_modules/subnet

Version:

### <a name="module_application_gateway"></a> [application\_gateway](#module\_application\_gateway)

Source: ../project2_modules/application-gateway

Version:

### <a name="module_private_dns_record"></a> [private\_dns\_record](#module\_private\_dns\_record)

Source: ../project2_modules/private_dns_record

Version:

### <a name="module_private_dns_zone"></a> [private\_dns\_zone](#module\_private\_dns\_zone)

Source: ../project2_modules/private_dns_zone

Version:

### <a name="module_private_dns_zone_vnet_link"></a> [private\_dns\_zone\_vnet\_link](#module\_private\_dns\_zone\_vnet\_link)

Source: ../project2_modules/private_dns_zone_vnet_link

Version:

### <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint)

Source: ../project2_modules/private_endpoint

Version:

### <a name="module_public_ip"></a> [public\_ip](#module\_public\_ip)

Source: ../project2_modules/public_ip

Version:

### <a name="module_ssl_certificate"></a> [ssl\_certificate](#module\_ssl\_certificate)

Source: ../project2_modules/ssl_certificate

Version:

### <a name="module_vmss"></a> [vmss](#module\_vmss)

Source: ../project2_modules/vmss

Version:

This is the project5 Configuration Terraform Files.
<!-- END_TF_DOCS -->