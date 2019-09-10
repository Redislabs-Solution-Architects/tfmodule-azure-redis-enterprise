locals {
  full_zone = (var.cluster-base-resource-group == null ? 1 : 0)
}

# If there's no upstream record to update, create one
resource "azurerm_dns_zone" "base" {
  count               = local.full_zone
  name                = "${var.cluster-base-domain}"
  resource_group_name = "${azurerm_resource_group.resource.name}"
}

resource "azurerm_dns_a_record" "fixedip" {
  count = var.node-count
  name = "ns${count.index}-${var.cluster-name}"
  zone_name           = "${var.cluster-base-domain}"
  resource_group_name  = "${(var.cluster-base-resource-group != null ? var.cluster-base-resource-group : azurerm_resource_group.resource.name)}"
  records =  [ "${element(data.azurerm_public_ip.fixedip.*.ip_address, count.index)}" ]
  # records = [ "${element(azurerm_network_interface.nic.*.private_ip_address, count.index)}" ]
  ttl                 = 300
}

# TODO - allow switching between public and private IP addressing in DNS
resource "azurerm_dns_ns_record" "fixedip" {
  count = var.node-count
  name                = "${var.cluster-name}"
  zone_name           = "${var.cluster-base-domain}"
  resource_group_name  = "${(var.cluster-base-resource-group != null ? var.cluster-base-resource-group : azurerm_resource_group.resource.name)}"
  ttl                 = 300
  # Has to have trailing periods on each record
  records = formatlist("%s.${var.cluster-base-domain}.", azurerm_dns_a_record.fixedip.*.name)
}
