locals {
  application_gateway_backend_address_pool_ids = [for pool in module.application_gateway.appgateway.backend_address_pool : pool.id]
}