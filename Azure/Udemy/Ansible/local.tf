locals {
  location = "East Asia"
  group_name = "tf-rg"
  virtual_network = {
    name = "tfvirnet"
    address_space = "10.0.0.0/16"
  }
}