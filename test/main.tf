provider "azurerm" {
}

module "azure" {
    source         = "../"
    cluster-name = "terraform-test-1"
    cluster-base-resource-group = "my-terraform-test"
    net-name = "terraform-test-1"
    common-tags = {
       Name = "terraform",
       Config = "terraform",
       Environment = "tf-test"
    }

  }