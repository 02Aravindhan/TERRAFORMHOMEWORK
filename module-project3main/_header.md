### Project2: Consume Modules to Create (VNET, Subnet, Resource Group, NSG, Route Table) 
* Resource Group (rg): Creates the foundation for all resources.
* Virtual Networks (vnets): Creates network spaces for subnets.
* Subnets (subnets): Defines smaller network spaces within the VNETs.
* Network Security Groups (nsg_name): Creates security rules for controlling network traffic.
* NSG Rules (nsg_rules): Defines specific inbound and outbound traffic rules for NSGs.
* NSG to Subnet Association (nsg-t0-subnets-asso): Applies the security rules (NSG) to subnets.
* Route Tables (route_table): Defines network routing the route table module to created.
* Route Table to Subnet Association (route-to-subnet-associate): Associates the routing logic with subnets.
* Each module has its own scope and configuration, and together they define a complete network infrastructure in Azure.