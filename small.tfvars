location    = "westus2"
av_zone     = ["1","2"]
net-name    = "redis-test"
net-cidr    = ["10.0.2.0/24"]
node-count  = 3
node-size   = "Standard_DS4_v2" # Standard_D13_v2 # Standard_E8as_v3 # Standard_DS13_v2
common-tags = { Config = "terraform", Environment = "tf-test" }
cluster-base-domain = "redis.life"
cluster-base-resource-group = "dns_entries" # if set, will create upstream DNS NS entry
cluster-name = "redis-test"
password = "EVENmoarSECURE"
node-publisher = "RedHat"
node-offer     = "RHEL"
node-sku       = "7-RAW"
node-version   = "latest"
re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/5.4.6/redislabs-5.4.6-11-rhel7-x86_64.tar"
demodb-name = "first-db"