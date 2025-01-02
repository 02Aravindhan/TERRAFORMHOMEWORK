resource_group = "module-rg"
location = "westeurope"

vnets={
  "modules_vnets" = {
      vnet_name = "modules_vnets"
      address_space = "10.0.0.0/16"
    }
}

subnets = {
  "modules_subnet" = {
       subnets_name="modules_subnet"
       address_prefixes="10.0.1.0/24"
  }
}

nsg_name ="module_nsg"
  

nsg_security_rules = {
  "nsg_rules"={
     name                       = "Allow_HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges     = ["80"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
     

  }

}

route_table = "module_routetable"