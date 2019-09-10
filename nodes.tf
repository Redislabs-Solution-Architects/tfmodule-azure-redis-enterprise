resource "azurerm_virtual_machine" "redis-nodes" {
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
  delete_os_disk_on_termination = true

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

  # TODO: Make the number and size of data disks configurable
  storage_data_disk {
      name                = "${var.net-name}-data-a-${count.index}"
      caching             = "ReadWrite"
      create_option       = "Empty"
      managed_disk_type   = "Premium_LRS"
      lun                 = 0
      disk_size_gb        = "256"
  }

  storage_data_disk {
      name                = "${var.net-name}-data-b-${count.index}"
      caching             = "ReadWrite"
      create_option       = "Empty"
      managed_disk_type   = "Premium_LRS"
      lun                 = 1
      disk_size_gb        = "256"
  }

  delete_data_disks_on_termination = true
  zones = [element(var.av_zone, count.index)]
  tags = merge({ Name = "${var.net-name}-${count.index}" }, var.common-tags)
}