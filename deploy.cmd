
terraform workspace select uswest2
terraform destroy --parallelism=20 -var-file="./env/mysettings.uswest2.tfvars" --auto-approve
terraform workspace select useast2
terraform destroy --parallelism=20 -var-file="./env/mysettings.useast2.tfvars" --auto-approve