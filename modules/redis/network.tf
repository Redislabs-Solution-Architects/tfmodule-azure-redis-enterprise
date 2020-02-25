resource "azurerm_resource_group" "resource" {
  name     = var.cluster-resource-group
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "network" {
  name                = var.net-name
  address_space       = var.net-cidr
  location            = var.location
  resource_group_name = azurerm_resource_group.resource.name  
}

output "network_id" {
  value = azurerm_virtual_network.network.idz`
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet-count
  name                 = "${var.net-name}-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.resource.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefix       = cidrsubnet(var.net-cidr[0], tostring(var.subnet-count), tostring(count.index))
}

resource "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = "${var.net-name}-${count.index}"
  location            = var.location
  zones               = [element(var.av_zone, count.index)]
  resource_group_name = azurerm_resource_group.resource.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count                     = var.node-count
  name                      = "${var.net-name}-${count.index}"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource.name
  network_security_group_id = azurerm_network_security_group.sg.id  

  ip_configuration {
    name                          = "${var.net-name}-${count.index}"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.fixedip.*.id, count.index)
  }
}

resource "azurerm_public_ip" "fixedip-client" {  
  name                = "${var.net-name}-client"
  location            = var.location
  zones               = [element(var.av_zone, 0)]
  resource_group_name = azurerm_resource_group.resource.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic-client" {  
  name                      = "${var.net-name}-client"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource.name
  network_security_group_id = azurerm_network_security_group.sg.id  

  ip_configuration {
    name                          = "${var.net-name}-client"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, 0)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.fixedip-client.id
  }
}

data "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = element(azurerm_public_ip.fixedip.*.name, count.index)
  zones               = [element(var.av_zone, count.index)]
  resource_group_name = azurerm_resource_group.resource.name
  depends_on          = [ azurerm_virtual_machine.redis-nodes, azurerm_network_interface.nic ]
}

data "azurerm_public_ip" "fixedip-client" {  
  name                = azurerm_public_ip.fixedip-client.name
  zones               = [element(var.av_zone, 0)]
  resource_group_name = azurerm_resource_group.resource.name
  depends_on          = [ azurerm_virtual_machine.redis-client, azurerm_network_interface.nic-client ]
}
