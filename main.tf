provider "azurerm" {
  version = "=1.28.0"
}

resource "azurerm_resource_group" "resource" {
  name     = var.net-name
  location = var.location
  tags     = merge({ Name = "${var.net-name}" }, var.common-tags)
}

resource "azurerm_virtual_network" "network" {
  name                = var.net-name
  address_space       = var.net-cidr
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"
  tags                = merge({Name = "${var.net-name}" }, var.common-tags)
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet-count
  name                 = "${var.net-name}-subnet-${count.index}"
  resource_group_name  = "${azurerm_resource_group.resource.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       =  "${cidrsubnet(var.net-cidr[0], tostring(var.subnet-count), tostring(count.index))}"
}

resource "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = "${var.net-name}-${count.index}"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"
  allocation_method   = "Dynamic"
  tags                = merge({Name = "${var.net-name}-${count.index}" }, var.common-tags)
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
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
  tags               = merge({Name = "${var.net-name}" }, var.common-tags)
}

resource "azurerm_network_interface" "nic" {
  count                     = var.node-count
  name                      = "${var.net-name}-${count.index}"
  location                  = var.location
  resource_group_name       = "${azurerm_resource_group.resource.name}"
  network_security_group_id = "${azurerm_network_security_group.sg.id}"
  tags                      = merge({Name = "${var.net-name}" }, var.common-tags)

  ip_configuration {
      name                          = "${var.net-name}-${count.index}"
      subnet_id                     = "${element(azurerm_subnet.subnet.*.id, count.index)}"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = "${element(azurerm_public_ip.fixedip.*.id, count.index)}"
  }

}

resource "azurerm_virtual_machine" "myterraformvm" {
  count                 = var.node-count
  name                  = "${var.net-name}-${count.index}"
  location              = var.location
  resource_group_name   = "${azurerm_resource_group.resource.name}"
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = var.node-size

  storage_os_disk {
      name              = "${var.net-name}-${count.index}"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
      publisher = var.node-publisher
      offer     = var.node-offer
      sku       = var.node-sku
      version   = var.node-version
  }

  os_profile {
      computer_name  = "${var.net-name}-${count.index}"
      admin_username = var.ssh-user
  }

  os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
          path     = "/home/${var.ssh-user}/.ssh/authorized_keys"
          key_data = "${file(var.ssh-key)}"
      }
  }

#    boot_diagnostics {
#        enabled     = "true"
#        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
#    }

  tags                      = merge({Name = "${var.net-name}-${count.index}" }, var.common-tags)
}
