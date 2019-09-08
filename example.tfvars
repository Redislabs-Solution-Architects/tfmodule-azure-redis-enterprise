location    = "westus2"
net-name    = "redisentpoc"
net-cidr    = ["10.0.1.0/24"]
node-count  = 3
node-size   = "Standard_DS4_v2"
common-tags = { Config = "terraform", Environment = "tf-test" }
cluster-base-domain = "redis.life"
cluster-name = "redisentpoc"
node-publisher = "RedHat"
node-offer     = "RHEL"
node-sku       = "7-RAW"
node-version   = "latest"
re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/5.4.6/redislabs-5.4.6-11-rhel7-x86_64.tar"
