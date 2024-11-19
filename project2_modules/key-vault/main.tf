# key_vault
resource "azurerm_key_vault" "Key_vault" {
  name                        = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  sku_name                    = var.sku_name
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id
 
    secret_permissions = var.secret_permissions
    certificate_permissions = var.certificate_permissions
    key_permissions = var.key_permissions
  }
  
}
