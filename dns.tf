resource "azurerm_dns_a_record" "fixedip" {
  provider            = azurerm.azurerm_vs
  count               = var.node-count
  name                = "ns${count.index}-${var.cluster-name}"
  zone_name           = var.cluster-base-domain
  resource_group_name = (var.cluster-base-resource-group != null ? var.cluster-base-resource-group : azurerm_resource_group.resource.name)
  records             =  [ element(data.azurerm_public_ip.fixedip.*.ip_address, count.index) ]  
  ttl                 = 300
  lifecycle {
    ignore_changes = [      
      records
    ]
  }
}

resource "azurerm_dns_ns_record" "fixedip" { 
  provider            = azurerm.azurerm_vs
  name                = var.cluster-name
  zone_name           = var.cluster-base-domain
  resource_group_name = (var.cluster-base-resource-group != null ? var.cluster-base-resource-group : azurerm_resource_group.resource.name)
  ttl                 = 300
  records             = formatlist("%s.${var.cluster-base-domain}.", azurerm_dns_a_record.fixedip.*.name)    
}
