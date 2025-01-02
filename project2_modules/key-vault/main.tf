# key_vault
resource "azurerm_key_vault" "Key_vault" {
  name                        = var.key_vault_name
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

resource "azurerm_key_vault_key" "key_vault_key" {
  name         = var. key_name
  key_vault_id = azurerm_key_vault.Key_vault.id
   key_opts     = var.key_opts
   key_size     = var.key_size
   key_type     = var.key_type  

   depends_on = [ azurerm_key_vault.Key_vault ]
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = var.admin_username
  value        = var.admin_username_value
  key_vault_id = azurerm_key_vault.Key_vault.id

  depends_on = [ azurerm_key_vault.Key_vault ]
}
resource "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password
  value        = var.admin_password_value
  key_vault_id = azurerm_key_vault.Key_vault.id

  depends_on = [ azurerm_key_vault.Key_vault,azurerm_key_vault_secret.admin_username ]
}