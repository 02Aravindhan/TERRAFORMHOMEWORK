rg_name ="project_rg"
location = "east asia"

vnets={
  "project_vnets" = {
      vnet_name = "project_vnets"
      address_space = "10.0.0.0/16"
    }
}
subnets = {
  "SubnetWeb" = {

      subnets_name="SubnetWeb"
      address_prefix="10.0.1.0/24"
    
  },

  "SubnetApp"={
      subnets_name="SubnetApp"
      address_prefix="10.0.2.0/24"
  },
  
  "SubnetLB"={
      subnets_name="SubnetLB"
      address_prefix="10.0.3.0/24"
  },
  
  "SubnetAPPGW"={
      subnets_name="SubnetAPPGW"
      address_prefix="10.0.4.0/24"
  }
}

