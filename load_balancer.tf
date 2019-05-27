resource "azurerm_public_ip" "lbip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"
  allocation_method   = "Static"
}

resource "azurerm_lb" "redislb" {
  name                = "Redis-Load-Balancer-${var.net-name}"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"
  frontend_ip_configuration {
    name                 = "PublicIPAddress-${var.net-name}"
    public_ip_address_id = "${azurerm_public_ip.lbip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${azurerm_resource_group.resource.name}"
  loadbalancer_id     = "${azurerm_lb.redislb.id}"
  name                = "BackendPool1"
}

resource "azurerm_lb_rule" "db-10002" {
  resource_group_name            = "${azurerm_resource_group.resource.name}"
  loadbalancer_id                = "${azurerm_lb.redislb.id}"
  name                           = "db-10002"
  protocol                       = "tcp"
  frontend_port                  = 10002
  backend_port                   = 10002
  frontend_ip_configuration_name = "PublicIPAddress-${var.net-name}"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db-10002.id}"
  depends_on                     = ["azurerm_lb_probe.db-10002"]
}

resource "azurerm_lb_probe" "db-10002" {
  resource_group_name = "${azurerm_resource_group.resource.name}"
  loadbalancer_id     = "${azurerm_lb.redislb.id}"
  name                = "tcpProbe"
  protocol            = "tcp"
  port                = 10002
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_nat_rule" "azlb-https-ui" {
  count                          = var.node-count
  resource_group_name            = "${azurerm_resource_group.resource.name}"
  loadbalancer_id                = "${azurerm_lb.redislb.id}"
  name                           = "HTTPS-UI-${count.index}"
  protocol                       = "tcp"
  frontend_port                  = "5000${count.index + 1}"
  backend_port                   = 8443
  frontend_ip_configuration_name = "PublicIPAddress-${var.net-name}"
}

resource "azurerm_lb_nat_rule" "azlb-vm-ssh" {
  count                          = var.node-count
  resource_group_name            = "${azurerm_resource_group.resource.name}"
  loadbalancer_id                = "${azurerm_lb.redislb.id}"
  name                           = "VM-SSH-${count.index}"
  protocol                       = "tcp"
  frontend_port                  = "5010${count.index + 1}"
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress-${var.net-name}"
}

resource "azurerm_network_interface_backend_address_pool_association" "redis" {
  count                   = var.node-count
  network_interface_id    = "${element(azurerm_network_interface.nic.*.id, count.index)}"
  ip_configuration_name   = "${var.net-name}-${count.index}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.backend_pool.id}"
}
