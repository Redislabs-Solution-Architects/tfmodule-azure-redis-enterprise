resource "azurerm_virtual_machine" "redis-client" {  
  count                 = var.client-count
  name                  = "${var.net-name}-client-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource.name  
  network_interface_ids = [element(azurerm_network_interface.nic-client.*.id, count.index)]
  vm_size               = "Standard_D2s_v3"

  storage_os_disk {
    name              = "${var.net-name}-client-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  delete_os_disk_on_termination = true

  storage_image_reference {    
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.net-name}-client-${count.index}"
    admin_username = var.ssh-user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.ssh-user}/.ssh/authorized_keys"
      key_data = file(var.ssh-key)
    }
  }

  zones = [element(var.av_zone, 0)]  
}