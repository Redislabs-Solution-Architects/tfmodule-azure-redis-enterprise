resource "azurerm_sql_firewall_rule" "fixedip-client" {
  name                = azurerm_dns_a_record" "fixedip-client
  count               = var.client-count
  resource_group_name = azurerm_resource_group.azuse2-devops-mgk-rg.name
  server_name         = azurerm_sql_server.mgk-sql-server.name
  start_ip_address    = element(data.azurerm_public_ip.fixedip-client.*.ip_address, count.index)
  end_ip_address      = element(data.azurerm_public_ip.fixedip-client.*.ip_address, count.index)
}