location    = "westus2"
net-name    = "maguec1"
net-cidr    = ["10.0.1.0/24"]
node-count  = 3
node-size   = "Standard_DS4_v2"
common-tags = { Config = "terraform", Environment = "tf-test" }
node-publisher = "RedHat"
node-offer     = "RHEL"
node-sku       = "7-RAW"
node-version   = "latest"