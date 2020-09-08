// Using the IP of the installer for security rules
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "sg" {
  name                = local.net-name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource.name
  tags                = merge({ Name = "${local.net-name}" }, var.common-tags)
}

resource "azurerm_network_security_rule" "install-ssh" {
  name                        = "SSH-rule"
  priority                    = 2001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${chomp(data.http.myip.body)}/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "https-ui" {
  name                        = "HTTPS-UI-rule"
  priority                    = 2000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "https-api" {
  name                        = "HTTPS-API-rule"
  priority                    = 2100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}


resource "azurerm_network_security_rule" "redis-dbs" {
  name                        = "DBs-rule"
  priority                    = 2009
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10001-19999"
  source_address_prefix       = "${chomp(data.http.myip.body)}/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "redis-sentinel" {
  name                        = "DB-Sentinel-rule"
  priority                    = 2006
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8001"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "dns-services" {
  name                        = "DNS-Server-rule"
  priority                    = 2027
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "public-ssh" {
  count                       = var.allow-public-ssh
  name                        = "Public-SSH-rule"
  priority                    = 2028
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "open-nets" {
  count                       = length(var.open-nets)
  name                        = "Open-Net-${count.index}"
  priority                    = "${format("%02d", count.index+3000)}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${element(var.open-nets, count.index)}"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource.name
  network_security_group_name = azurerm_network_security_group.sg.name
}
