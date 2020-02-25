resource "azurerm_resource_group" "resource" {
  name     = "azuse2-devops-mgk"
  location = "eastus2"
  tags     = local.tags
}

resource "azurerm_virtual_network_peering" "peering-useast2" {  
  name                          = "peering-to-${element(var.locations, 1).net-name}"
  resource_group_name           = element(var.locations, 0).cluster-resource-group
  virtual_network_name          = element(var.locations, 0).net-name
  remote_virtual_network_id     = module.redis_cluster-uswest2.network_id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  depends_on                    = [ module.redis_cluster-useast2, module.redis_cluster-uswest2 ]
}

resource "azurerm_virtual_network_peering" "peering-uswest2" {  
  name                          = "peering-to-${element(var.locations, 0).net-name}"
  resource_group_name           = element(var.locations, 1).cluster-resource-group
  virtual_network_name          = element(var.locations, 1).net-name
  remote_virtual_network_id     = module.redis_cluster-useast2.network_id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  depends_on                    = [ module.redis_cluster-useast2, module.redis_cluster-uswest2 ]
}