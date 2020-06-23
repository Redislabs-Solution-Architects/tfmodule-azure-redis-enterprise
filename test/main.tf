provider "azurerm" {
}

module "azure" {
  source       = "../"
  location     = "us2west" # broken on purpose so you can't create resoruces
  cluster-name = "terraform-test-1.azure.example.com"
  common-tags = {
    Owner       = "Ken_Watanabe@example.com",
    Config      = "terraform",
    Environment = "tf-test"
  }

}
