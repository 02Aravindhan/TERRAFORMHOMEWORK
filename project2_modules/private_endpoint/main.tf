

resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  name                = var.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            =var.location
  subnet_id           = var.subnet_id
  
  private_service_connection {
    name                           = var.name
    private_connection_resource_id = var.private_connection_resource_id
    
    subresource_names = [ "vault" ]
    is_manual_connection          = var.is_manual_connection
  
  }
  
}