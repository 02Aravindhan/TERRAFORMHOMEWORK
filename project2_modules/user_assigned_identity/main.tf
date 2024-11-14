# Creates the Managed user identity
resource "azurerm_user_assigned_identity" "user_ass_identity" {
  name                =var.user_ass_identity_name                   //"appgw-user_identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  
}