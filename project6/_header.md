### project6:Use project 03, 04, and 05 as Data Block (Azure Firewall, Route Outbound Traffic)
* First we have  depand to  data block create the  Resource Group for 'project5-rg"
* vnet: We should depand on data block to create the Virtual Network for vnet with address space.
* Subnet 11: The vnet has subnet11 with address prefixes.
#### Modules:
* Modules in Terraform allow you to group resources together for reusability. This code uses multiple modules to manage specific resources.

## Firewall Subnet:
* Creates subnets (specifically for firewall usage), with each subnet's name and address prefix being dynamically set via for_each on the variable var.firewall_subnet.
The subnet configuration is linked to the existing VNet and Resource Group.

## Firewall Public IP:
* Creates a static public IP address for the firewall.
* The IP is set to Standard SKU and is associated with the resource group .

## Firewall Policy:
* Creates a new firewall policy (firewall-policy) in the resource group and location.
* The SKU is set to Standard.

## Firewall:
* Creates a firewall (firewall) resource that is associated with the previously created public IP and firewall policy.
* It also connects the firewall to the correct subnet (AzureFirewallSubnet) and the VNet's security group.

## Route Table:
* Creates a route table that will be used to define routing logic for traffic.

## Firewall Route:
* Creates a route within the previously defined route table.
The route directs all traffic (0.0.0.0/0) to the firewall (via next_hop_in_ip_address set to 10.0.8.4), which is a common setup for directing traffic through a centralized firewall.

## Route Table Association:

* Associates the route table with a subnet (subnet11) within the resource group, ensuring that all traffic to/from this subnet follows the defined route table.

## Network Security Group (NSG):
* Creates a network security group (NSG) for controlling network traffic based on security rules.

## NSG Rules:
* Creates security rules (inbound or outbound traffic control) based on variables like name, priority, access, protocol, port ranges, etc. These rules are tied to the NSG created earlier.

## NSG Association to Subnet:
* Associates the created NSG to a specific subnet (subnet11), applying the security rules defined earlier.