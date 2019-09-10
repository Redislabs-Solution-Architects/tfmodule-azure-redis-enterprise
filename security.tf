// Using the IP of the installer for security rules
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "sg" {
  name                = "${var.net-name}"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS-UI"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DBs"
    priority                   = 1009
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10001-19999"
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DB-Sentinel"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # security_rule {
  #   name                       = "Prometheus"
  #   priority                   = 1007
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "8070"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  security_rule {
    name                       = "DNS-Server"
    priority                   = 1027
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge({ Name = "${var.net-name}" }, var.common-tags)

}
