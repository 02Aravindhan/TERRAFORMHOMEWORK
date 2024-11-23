### project5: Use PROJECT 03 and 04 as Data Block (VMSS, Application Gateway, SSL, Key Vault, etc.)

* First we have  depand to  data block create the  Resource Group for 'project4-rg"
* vnet: We should depand on data block to create the Virtual Network for vnet with address space.
* Subnet 22: The vnet has subnet22 with address prefixes
* VMSS: Deploy a Virtual Machine Scale Set in Subnet 22.The VMSS should support  capabilities and SSL certificate termination (Use Application Gateway).
* Application Gateway: Route traffic using Application Gateway.
* SSL Certificate: Store SSL certificates in Key Vault and integrate them with the Application Gateway.
* Private Endpoint: Create a private endpoint for Key Vault.
* Managed Identity: Assign managed identities to the VMSS for secure access to Azure resources.
* We need to create the Azure Key valut service to store the VM username and password.