resource "azurerm_sql_server" "mgk-sql-server" {
  name                          = "mgk-sql-server"
  resource_group_name           = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location                      = azurerm_resource_group.azuse2-devops-mgk-rg.location
  version                       = "12.0"
  administrator_login           = "redis"
  administrator_login_password  = "EVENmoarSECURE!"
}

resource "azurerm_sql_database" "mgk-sql" {
  name                              = "mgk-sql"
  resource_group_name               = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location                          = azurerm_resource_group.azuse2-devops-mgk-rg.location
  server_name                       = azurerm_sql_server.mgk-sql-server.name
  elastic_pool_name                 = azurerm_mssql_elasticpool.mgk-sql-pool.name  
  edition                           = "Basic"
  requested_service_objective_name  = "ElasticPool"  
  tags                              = local.tags  
}

resource "azurerm_mssql_elasticpool" "mgk-sql-pool" {
  name                  = "mgk-sql-pool"
  resource_group_name   = azurerm_resource_group.azuse2-devops-mgk-rg.name
  location              = azurerm_resource_group.azuse2-devops-mgk-rg.location
  server_name           = azurerm_sql_server.mgk-sql-server.name
  max_size_gb           = 4.8828125 

  sku {
    name     = "BasicPool"
    tier     = "Basic"    
    capacity = 50
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 5
  }
}