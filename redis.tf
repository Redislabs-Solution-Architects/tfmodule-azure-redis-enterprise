module "redis_cluster-useast2"  {
    source                          = "./modules/redis"

    # Count not yet implemented for modules
    
    # Unique to the location
    location                        = element(var.locations, 0).location
    cluster-resource-group          = element(var.locations, 0).cluster-resource-group
    net-cidr                        = element(var.locations, 0).net-cidr
    cluster-base-domain             = element(var.locations, 0).cluster-base-domain
    net-name                        = element(var.locations, 0).net-name

    # Common to all locations in our cluster
    cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
    av_zone                         = var.av_zone    
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

    # Count not yet implemented for modules
    
    # Unique to the location
    location                        = element(var.locations, 1).location
    cluster-resource-group          = element(var.locations, 1).cluster-resource-group
    net-cidr                        = element(var.locations, 1).net-cidr
    cluster-base-domain             = element(var.locations, 1).cluster-base-domain
    net-name                        = element(var.locations, 1).net-name

    # Common to all locations in our cluster
    cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
    av_zone                         = var.av_zone    
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