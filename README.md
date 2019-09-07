# redis-enterprise-azure-terraform
Public Azure Instance setup

Use this to quickly set up a demonstration Redis Enterprise environment on Microsoft Azure.

By default, this will set up a single 7 node cluster with Redis-on-Flash enabled via a RAID-1 pair of SSD data disks. This cluster will have 3 nodes in one Availability Zone and 4 in a separate one, guaranteeing that all of your databases will survive a complete AZ failure.
You can also use this to set up two clusters in two separate Azure regions; these two clusters can then be connected as part of an Active-Active set for CRDB databases. Or, you can use them for Active-Passive failover using "replica-of".

```
cp example.tfvars mysettings.tfvars
terraform init
terraform apply -var-file="mysettings.tfvars" 
```

Make sure that you're using an ssh key without a passphrase. (If necessary, create a new SSH key using `ssh-keygen` and change the `ssh-key` variable to match.)

It's recommended that you use a FQDN for the cluster name, and set up the appropriate DNS records. 
