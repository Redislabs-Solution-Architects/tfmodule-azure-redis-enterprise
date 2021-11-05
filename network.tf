resource "azurerm_resource_group" "resource" {
  name     = local.net-name
  location = var.location
  tags     = merge({ Name = "${local.net-name}" }, var.common-tags)
}

resource "azurerm_virtual_network" "network" {
  name                = local.net-name
  address_space       = var.net-cidr
  location            = var.location
  resource_group_name = azurerm_resource_group.resource.name
  tags                = merge({ Name = "${local.net-name}" }, var.common-tags)
}

resource "azurerm_subnet" "subnet" {
  count                = local.subnet-count
  name                 = "${local.net-name}-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.resource.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [cidrsubnet(var.net-cidr[0], tostring(local.subnet-count), tostring(count.index))]
}

resource "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = "${local.net-name}-${count.index}"
  location            = var.location
  zones               = [element(var.av_zone, count.index)]
  resource_group_name = azurerm_resource_group.resource.name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = merge({ Name = "${local.net-name}-${count.index}" }, var.common-tags)
}

resource "azurerm_network_interface" "nic" {
  count                         = var.node-count
  enable_accelerated_networking = var.accelerated-networking
  name                          = "${local.net-name}-${count.index}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.resource.name
  tags                          = merge({ Name = "${local.net-name}" }, var.common-tags)

  ip_configuration {
    name                          = "${local.net-name}-${count.index}"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.fixedip.*.id, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "sg2nic" {
  count                     = var.node-count
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.sg.id
}


data "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = element(azurerm_public_ip.fixedip.*.name, count.index)
  zones               = [element(var.av_zone, count.index)]
  resource_group_name = azurerm_resource_group.resource.name
  depends_on          = [azurerm_virtual_machine.redis-nodes, azurerm_network_interface.nic]
}
