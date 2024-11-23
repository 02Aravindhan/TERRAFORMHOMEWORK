subnets = {
  "subnet11" = {
       subnets_name="subnet11"
       address_prefix="10.0.5.0/24"
  },
  "subnet22" = {
       subnets_name="subnet22"
       address_prefix="10.0.6.0/24"
  }
}
firewall_subnet = {
  
  "AzureFirewallSubnet" = {
    subnet_name = "AzureFirewallSubnet"
    address_prefix = "10.0.8.0/24"
  }
  }
  
route_table_name  = "firewall-routetable"

nsg_name = "firewall-nsg" 


security_rules= {
    "firewall-nsg" = {
    name                       = "allow_port"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22","80","443", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    nsg_name                   = "firewall-nsg"
    }
}