resource "azurerm_resource_group" "tf-rsg" {
  name     = local.name_of_rsg
  location = local.name_of_location
}

module "network" {
  source = "./modules/network"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg
  depends_on = [ 
    azurerm_resource_group.tf-rsg
  ]
}

module "vm" {
  source = "./modules/vm"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg
  subnet_id  = module.network.nw_subnet_id
  depends_on = [
    module.network
  ]
}

module "mgnt" {
  source = "./modules/mngnt"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg
  winvm_id = module.vm.winvm_id
  depends_on = [ 
    module.vm
  ]
}

# module "data" {
#   source = "./modules/data"
# }