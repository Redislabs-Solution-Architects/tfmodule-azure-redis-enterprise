resource "azurerm_sql_server" "mgk-sql-server" {
  name                          = "mgk-sql-server"
  resource_group_name           = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location                      = azurerm_resource_group.azuse2-devops-mgk-rg.location
  version                       = "12.0"
  administrator_login           = "redis"
  administrator_login_password  = "EVENmoarSECURE!"
}

resource "azurerm_sql_database" "mgk-sql" {
  name                  = "mgk-sql"
  resource_group_name   = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location              = azurerm_resource_group.azuse2-devops-mgk-rg.location
  server_name           = azurerm_sql_elasticpool.mgk-sql-pool.name
  tags                  = local.tags  
}

resource "azurerm_sql_elasticpool" "mgk-sql-pool" {
  name                  = "mgk-sql-pool"
  resource_group_name   = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location              = azurerm_resource_group.azuse2-devops-mgk-rg.location
  server_name           = azurerm_sql_server.mgk-sql-server.name
  edition               = "Basic"
  dtu                   = 50
  db_dtu_min            = 0
  db_dtu_max            = 5  
  //pool_size             = 32
}