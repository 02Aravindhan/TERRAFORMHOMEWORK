 ## project2:CREATE MODULES
 1.RESOURCE GROUP:
 *   Implement a module to create resource groups that can be reused across different environments.S
 2.VNET:
  * VNet Creation: This module uses the for_each loop to create multiple VNets based on the var.vnets variable, which could be a map or a list of VNet      configurations.
  * Address Space: Each VNet gets an address_space defined in the var.vnets variable.

3.SUBNETS:
   *  Subnet Creation: This module creates subnets within the virtual networks created in the previous step. It uses for_each to iterate through the subnets configuration in var.subnets.
   *  Address Prefixes: Each subnet is assigned an address_prefixes parameter.

4.NSG
 * NSG Module: Build a module that allows creating NSGs with customizable security rules. Accept rules for inbound and outbound traffic via parameter 

5.ROUTE TABLE
 *  Create a module for route tables, where routes can be easily added. Allow adding custom routes.
 *  A Route Table in Azure allows you to control routing for the subnets. It is important for managing network traffic within and between VNets.