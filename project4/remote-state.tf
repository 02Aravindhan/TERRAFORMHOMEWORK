data "terraform_remote_state" "project4" {
  backend = "azurerm"
  config = {
    resource_group_name = "RemoteState-rg"
    storage_account_name = "projectstorageaccount11"
    container_name = "storage-backend"
    key = "project4-backend.tfstate"
  }
}