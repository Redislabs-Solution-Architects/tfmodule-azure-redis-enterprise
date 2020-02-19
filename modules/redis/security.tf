// Using the IP of the installer for security rules
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "sg" {
  name                = var.net-name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource.name
  
  security_rule {    
    name                       = "SSH"
    priority                   = 801
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${element(var.ssh-allowip, 0)}/32"    
    destination_address_prefix = "*"
  }

  security_rule {    
    name                       = "SSH"
    priority                   = 802
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${element(var.ssh-allowip, 1)}/32"    
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
    name                       = "Sync"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "20001-29999"
    source_address_prefix      = "*"    
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DBs"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "10001-19999"
    source_address_prefix      = "*"    
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

   security_rule {
     name                       = "Prometheus"
     priority                   = 1007
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "8070-8071"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
   }
   
   security_rule {
     name                       = "RESTAPIONE"
     priority                   = 1008
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "9443"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
   }   

   security_rule {
     name                       = "RESTAPITWO"
     priority                   = 1009
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "8080"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
   }      

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

  security_rule {
    name                       = "Alt-DNS-Server"
    priority                   = 1028
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "5353"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
