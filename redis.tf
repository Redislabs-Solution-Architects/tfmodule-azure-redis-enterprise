module "redis_cluster-useast2"  {
    source                          = "./modules/redis"

    # Count not yet implemented for modules
    
    # Unique to the location
    location                        = element(var.locations, 0).location
    cluster-resource-group          = element(var.locations, 0).cluster-resource-group
    net-cidr                        = element(var.locations, 0).net-cidr    
    net-name                        = element(var.locations, 0).net-name
    cluster-name                    = element(var.locations, 0).cluster-name

    # Common to all locations in our cluster
    cluster-base-domain             = var.cluster-base-domain
    cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
    av_zone                         = var.av_zone        
    username                        = var.username
    password                        = var.password    
    re-download-url                 = var.re-download-url
    demodb-name                     = var.demodb-name
    node-size                       = var.node-size
    ssh-allowip                     = var.ssh-allowip

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
    net-name                        = element(var.locations, 1).net-name
    cluster-name                    = element(var.locations, 1).cluster-name

    # Common to all locations in our cluster
    cluster-base-domain             = var.cluster-base-domain
    cluster-base-resource-group     = var.cluster-base-resource-group
    av_zone                         = var.av_zone        
    username                        = var.username
    password                        = var.password    
    re-download-url                 = var.re-download-url
    demodb-name                     = var.demodb-name
    node-size                       = var.node-size
    ssh-allowip                     = var.ssh-allowipmodule.

    # Tags
    cost_center                     = var.cost_center
    business_unit                   = var.business_unit
    owner                           = var.owner
    environment                     = var.environment
    platform_application            = var.platform_application
    compliance_data_profile         = var.compliance_data_profile
    data_sovereignty_location       = var.data_sovereignty_location
}