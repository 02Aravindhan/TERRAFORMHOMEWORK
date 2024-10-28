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


# nsg_rules={
#  "nsg_rules1"= {
#     name                       = "Allow_HTTP"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   },
#    "nsg_rules2"= {
#     name                       = "Allow_HTTPS"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   },

#  "nsg_rules3"= {
#     name                       = "Deny_All_Other"
#     priority                   = 2000
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

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


