locals {
  name_of_location = "Southeast Asia"
  name_of_rsg = ["sea-mgnt-rg-ns-01", "sea-test-rg-ns-01"]
  name_of_vnet = ["sea-mgnt-vnet-ns-01", "sea-test-vnet-ns-01"]
  vnet_address_space = ["10.10.0.0/16", "10.11.0.0/16"]
  name_of_tags = {
    deploy = "terraform",
    author = "tp"
  }
}