module "redis_cluster-useast2"  {
    source                          = "./modules/redis"
    
    # Unique to the location
    location                        = "eastus2"
    cluster-resource-group          = "azuse2-redis-test"    
    net-cidr                        = ["10.0.2.0/24"]
    cluster-base-domain             = "useast2.kaiser.guru"

    # Common to all locations in our cluster
    cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
    av_zone                         = var.av_zone
    net-name                        = var.net-name          
    cluster-name                    = var.cluster-name
    username                        = var.username
    password                        = var.password    
    re-download-url                 = var.re-download-url
    demodb-name                     = var.demodb-name
    node-size                       = var.node-size

    # Tags
    cost_center                     = var.cost_center
    business_unit                   = var.business_unit
    owner                           = var.owner
    environment                     = var.environment
    platform_application            = var.platform_application
    compliance_data_profile         = var.compliance_data_profile
    data_sovereignty_location       = var.data_sovereignty_location
}

module "redis_cluster-uswest2"  {
    source                          = "./modules/redis"
    
    # Unique to the location
    location                        = "westus2"
    cluster-resource-group          = "azusw2-redis-test"    
    net-cidr                        = ["10.0.3.0/24"]
    cluster-base-domain             = "uswest2.kaiser.guru"

    # Common to all locations in our cluster
    cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
    av_zone                         = var.av_zone
    net-name                        = var.net-name          
    cluster-name                    = var.cluster-name
    username                        = var.username
    password                        = var.password    
    re-download-url                 = var.re-download-url
    demodb-name                     = var.demodb-name
    node-size                       = var.node-size

    # Tags
    cost_center                     = var.cost_center
    business_unit                   = var.business_unit
    owner                           = var.owner
    environment                     = var.environment
    platform_application            = var.platform_application
    compliance_data_profile         = var.compliance_data_profile
    data_sovereignty_location       = var.data_sovereignty_location
}