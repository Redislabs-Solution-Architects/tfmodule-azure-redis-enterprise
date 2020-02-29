# Common to all locations in cluster
av_zone                         = ["1","2"]
cluster-base-domain             = "kaiser.guru"
username                        = "demo@redislabs.com"
password                        = "EVENmoarSECURE"
re-download-url                 = "https://s3.amazonaws.com/redis-enterprise-software-downloads/5.4.10/redislabs-5.4.10-22-rhel7-x86_64.tar"
demodb-name                     = "first-db"
cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"

# Tags
cost_center                     = "57601"
business_unit                   = "4116"
owner                           = "mkaiser@incomm.com"
environment                     = "POC"
platform_application            = "Serve"
compliance_data_profile         = "NON-PCI"
data_sovereignty_location       = "US"
ssh-allowip                     = ["50.238.128.77/32", "35.138.147.194/32"]
locations                       = [
                                    {
                                        location                        = "southcentralus"
                                        cluster-resource-group          = "azuse2-redis-test"    
                                        net-cidr                        = ["10.0.2.0/24"]      
                                        net-name                        = "redis-test-eastus2"    
                                        cluster-name                    = "redis-test-east"  
                                    },
                                    {
                                        location                        = "westus"
                                        cluster-resource-group          = "azusw2-redis-test"    
                                        net-cidr                        = ["10.0.3.0/24"]      
                                        net-name                        = "redis-test-westus2"
                                        cluster-name                    = "redis-test-west"        
                                    }
                                ]