# redis-enterprise-azure-terraform

Public Azure Instance setup

Use this to quickly set up a Redis Enterprise environment on Microsoft Azure.

By default, this will set up a single 3, 5 or 7 node cluster with Redis-on-Flash enabled via a RAID-1 pair of SSD data disks. This cluster will have nodes in two Availability Zones, guaranteeing that all of your databases will survive a complete AZ failure.
You can also use this to set up two clusters in two separate Azure regions; these two clusters can then be connected as part of an Active-Active set for CRDB databases. Or, you can use them for Active-Passive failover using "replica-of".

## Log in to Azure
```BASH
az login
```

## Initialize terraform using Azure Storage
```BASH
terraform init -backend-config="storage_account_name=azuse2devopsstore" -backend-config="container_name=tfstate" -backend-config="access_key=x7VnVoswQvNA0M79JRGAaLhqZ32/PVNzFLSQCRT4ZKkW19NC4q9jFsFrrSGB5L2XVMAiwm487iLwyVLVc1Q1LQ==" -backend-config="key=redis.terraform-azure.tfstate"
```

## Apply

```BASH
terraform apply --parallelism=20 
```

## Log in

You can use the web address of any of the nodes (in the terraform output) to access the web interface. If you set the `demodb-name` variable, then you can try connecting to that database immediately:

```BASH
redis-cli -h "YOURDBADDRESS" -p PORTNUMBER -a PASSWORD
```

## Generate Documentation
```BASH
terraform-docs markdown --no-sort ./modules/redis > docs/redis.md
terraform-docs markdown --no-sort . > docs/main.md
```

## Redis CLI
```BASH
npm install -g redis-cli
rdcli -h redis-12000.redis-test-west.kaiser.guru -p 12000 -a p@ssw0rd!
```

## Useful CRDB stuff
```BASH
ssh redislabs@ns1-redis-test-east.kaiser.guru -i ~/.ssh/id_rsa_azure
crdb-cli crdb list
crdb-cli crdb flush --crdb-guid 9f4c453b-c324-4c64-87a7-63302bcac4c3
crdbtop 9f4c453b-c324-4c64-87a7-63302bcac4c3
```