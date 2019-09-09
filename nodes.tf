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
# storage_data_disk {
# 
# }

  #    boot_diagnostics {
  #        enabled     = "true"
  #        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  #    }

  tags = merge({ Name = "${var.net-name}-${count.index}" }, var.common-tags)
}


# TODO: Add a jumpbox to run a client on