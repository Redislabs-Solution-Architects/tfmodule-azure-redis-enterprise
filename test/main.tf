provider "azurerm" {
}

module "azure" {
  source       = "../"
  cluster-name = "terraform-test-1.azure.example.com"
  common-tags = {
    Owner       = "Ken_Watanabe@example.com",
    Config      = "terraform",
    Environment = "tf-test"
  }

}
