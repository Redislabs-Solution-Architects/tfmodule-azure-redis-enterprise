# redis-enterprise-azure-terraform

Public Azure Instance setup

Use this to quickly set up a Redis Enterprise environment on Microsoft Azure.

By default, this will set up a single 3, 5 or 7 node cluster with Redis-on-Flash enabled via a RAID-1 pair of SSD data disks. This cluster will have nodes in two Availability Zones, guaranteeing that all of your databases will survive a complete AZ failure.
You can also use this to set up two clusters in two separate Azure regions; these two clusters can then be connected as part of an Active-Active set for CRDB databases. Or, you can use them for Active-Passive failover using "replica-of".

## Log in to Azure
```BASH
az login
```

## Step One: Prepare your inputs

Pick one of the example tfvars to use (small is... smaller, and perf-test is for running performance tests. Example is generically pretty good.)

```BASH
cp example.tfvars mysettings.tfvars
```

## Initialize terraform using Azure Storage
```BASH
terraform init -backend-config="storage_account_name=azuse2devopsstore" -backend-config="container_name=tfstate" -backend-config="access_key=x7VnVoswQvNA0M79JRGAaLhqZ32/PVNzFLSQCRT4ZKkW19NC4q9jFsFrrSGB5L2XVMAiwm487iLwyVLVc1Q1LQ==" -backend-config="key=redis.terraform-azure.tfstate"
```

Make sure to update the variables in terraform.tfvars, especially `password` and `cluster-base-domain`. It's simplest if you have a spare domain name for demos, as this recipe will set up a complete zone file, but you can use a delegated subzone instead. If you host DNS for the base domain in Azure, specify the resource group that the zone file is in with `cluster-base-resource-group` and this will add A and NS records to that zone file (instead of setting up a complete zone).

Make sure that you're using an ssh key without a passphrase. (If necessary, create a new SSH key using `ssh-keygen` and change the `ssh-key` variable to match.)

## Step Two: Apply

```BASH
terraform apply --parallelism=20 
```

Once the apply has finished, you might need to add NS records (either for the domain or delegated subzone) to your upstream DNS.

## Step Three: Log in

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
rdcli -h redis-10002.redis-test-west.kaiser.guru -p 10002 -a p@ssw0rd!
```