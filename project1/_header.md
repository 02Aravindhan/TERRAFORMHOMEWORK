 project1: Basic Azure Resources Setup (VNET, Subnet, Resource Group, NSG, Route Table)

   * First we have to create the Resource Group
   * The name of the VNet, taken from the map key.address_space: The IP address range for the VNet  
   * The name of the subnet.address_prefixes: The IP address range for the subnet.
   * virtual_network_name: Associates the subnet with the specified VNet.
   * Virtual Network (VNET): Create a VNET with a specific address space .
   * Network Security Group (NSG): Associate an NSG with subnets.defining security rules to control inbound and outbound traffic.
   *   Route Table: Create a custom route table and associate it with a subnet.