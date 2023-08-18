module "general_module" {
  source = "./modules/general"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg
  name_of_vnet = local.name_of_vnet
  vnet_address_space = local.vnet_address_space
  name_of_tags = local.name_of_tags
}

module "mgnt_module" {
  source = "./modules/mgnt"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg[0]
  name_of_vnet = local.name_of_vnet[0]
  vnet_address_space = local.vnet_address_space[0]
  name_of_tags = local.name_of_tags
  depends_on = [ 
    module.general_module
  ]
}

module "test_moduel" {
  source = "./modules/test"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg[1]
  name_of_vnet = local.name_of_vnet[1]
  vnet_address_space = local.vnet_address_space[1]
  name_of_tags = local.name_of_tags
  depends_on = [ 
    module.general_module
  ]
}