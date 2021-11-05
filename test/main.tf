provider "azurerm" {
}

module "azure" {
  source           = "../"
  location         = "westus2" # broken on purpose so you can't create resoruces
  cluster-name     = "terraform-test-1.azure.example.com"
  allow-public-ssh = 1
  open-nets        = ["10.0.0.12/32"]
  common-tags = {
    Owner       = "Ken_Watanabe@example.com",
    Config      = "terraform",
    Environment = "tf-test"
  }

}
