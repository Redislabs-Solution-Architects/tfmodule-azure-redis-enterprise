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
  tags                = merge({ Name = "${var.net-name}" }, var.common-tags)
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet-count
  name                 = "${var.net-name}-subnet-${count.index}"
  resource_group_name  = "${azurerm_resource_group.resource.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${cidrsubnet(var.net-cidr[0], tostring(var.subnet-count), tostring(count.index))}"
}

resource "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = "${var.net-name}-${count.index}"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.resource.name}"
  allocation_method   = "Dynamic"
  tags                = merge({ Name = "${var.net-name}-${count.index}" }, var.common-tags)
}

data "azurerm_public_ip" "fixedip" {
  count               = var.node-count
  name                = "${element(azurerm_public_ip.fixedip.*.name, count.index)}"
  resource_group_name = "${azurerm_resource_group.resource.name}"
  depends_on          = ["azurerm_virtual_machine.myterraformvm"]
}

resource "azurerm_network_interface" "nic" {
  count                     = var.node-count
  name                      = "${var.net-name}-${count.index}"
  location                  = var.location
  resource_group_name       = "${azurerm_resource_group.resource.name}"
  network_security_group_id = "${azurerm_network_security_group.sg.id}"
  tags                      = merge({ Name = "${var.net-name}" }, var.common-tags)

  ip_configuration {
    name                          = "${var.net-name}-${count.index}"
    subnet_id                     = "${element(azurerm_subnet.subnet.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.fixedip.*.id, count.index)}"
  }

}


resource "azurerm_dns_zone" "fixedip" {
  name                = "${var.cluster-base-domain}"
  resource_group_name  = "${azurerm_resource_group.resource.name}"
  depends_on          = ["azurerm_virtual_machine.myterraformvm"]
}

# TODO - Delegated subzone by DNS NS records added to the parent zone, using the NS entries from above

resource "azurerm_dns_a_record" "fixedip" {
  count = var.node-count
  name = "ns${count.index}-${var.cluster-name}"
  zone_name           = "${azurerm_dns_zone.fixedip.name}"
  resource_group_name  = "${azurerm_resource_group.resource.name}"
  # records = data.azurerm_public_ip.fixedip.*.ip_address
  records = [ "${element(azurerm_network_interface.nic.*.private_ip_address, count.index)}" ]
  ttl                 = 300

}

resource "azurerm_dns_ns_record" "fixedip" {
  count = var.node-count
  name                = "${var.cluster-name}.${var.cluster-base-domain}"
  zone_name           = "${azurerm_dns_zone.fixedip.name}"
  resource_group_name  = "${azurerm_resource_group.resource.name}"
  ttl                 = 300
  # Need trailing periods on each record
  records = formatlist("%s.${var.cluster-base-domain}.", azurerm_dns_a_record.fixedip.*.name)
}