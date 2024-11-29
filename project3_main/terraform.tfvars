resource_group = "module2-rg"
location = "westeurope"

vnets={
  "modules_vnets" = {
      vnet_name = "modules_vnets"
      address_space = "10.0.0.0/16"
    }
}

subnets = {
  "subnet1" = {
       subnets_name="subnet1"
       address_prefixes="10.0.1.0/24"
  },
  "subnet2" = {
       subnets_name="subnet2"
       address_prefixes="10.0.2.0/24"
  },
  "subnet3" = {
       subnets_name="subnet3"
       address_prefixes="10.0.3.0/24"
  },
  "subnet4" = {
       subnets_name="subnet4"
       address_prefixes="10.0.4.0/24"
  }
  
}

nsg_name ={
  "nsg1"={
       name="nsg1"
  },
  "nsg2"={
       name="nsg2"
},
"nsg3"={
       name="nsg3"
},
"nsg4"={
       name="nsg4"
}

}


nsg_rules={
 "nsg_rules1"= {
    name                       = "Allow_HTTP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    nsg_name ="nsg1"
   },
   "nsg_rules2"= {
    name                       = "Allow_HTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    nsg_name  ="nsg2"
  },

"nsg_rules3"= {
    name                       = "Allow_HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80","443","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    nsg_name  ="nsg3"
  },

  "nsg_rules4"= {
    name                       = "Allow"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    nsg_name  ="nsg4"
  }

}

route_table = {
  "routetable1" = {
    name="routetable1"
    
  },
  "routetable2" = {
    name="routetable2"
    
  },
  "routetable3" = {
    name="routetable3"
    
  },
  "routetable4" = {
    name="routetable4"
    
  }
  
}

nsg-to-subnets-associate = {
  
  "nsg1" = {
    subnets_name="subnet1"
    nsg_name="nsg1"
    
  },
  "nsg2" = {
    subnets_name="subnet2"
    nsg_name="nsg2"
    
  },
  "nsg3" = {
    subnets_name="subnet3"
    nsg_name="nsg3"
    
  },
  "nsg4" = {
    subnets_name="subnet4"
    nsg_name="nsg4"
    
  }

}

route-to-subnets-associate = {

  "routetable1" = {
    subnets_name="subnet1"
      
  },
  "routetable2" = {
    subnets_name="subnet2"
      
  },
  "routetable3" = {
    subnets_name="subnet3"
      
  },
  "routetable4" = {
    subnets_name="subnet4"
      
  }
  
}