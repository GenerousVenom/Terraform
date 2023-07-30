module "general_module" {
  source = "./modules/general"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg
  vnet_address_space = local.vnet_address_space
}

module "dmgmt_module" {
  source = "./modules/dmgmt"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg[0]
  name_of_subnet_dmgmt = local.name_of_subnet_dmgmt
  subnet_address_space_dmgmt = local.subnet_address_space_dmgmt
  name_of_stracc = local.name_of_stracc
  name_of_keyvault = local.name_of_keyvault
  onpre_public_ip_dmgmt = local.onpre_public_ip_dmgmt
  onpre_subnet_space_dmgmt = local.onpre_subnet_space_dmgmt
  depends_on = [ 
    module.general_module
  ]
}

module "prd_module" {
  source = "./modules/production"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg[1]
  name_of_subnet_prd = local.name_of_subnet_prd
  subnet_address_space_prd = local.subnet_address_space_prd
  depends_on = [ 
    module.general_module
  ]
}

module "nonpro_module" {
  source = "./modules/nonproduction"
  name_of_location = local.name_of_location
  name_of_rsg = local.name_of_rsg[2]
  name_of_subnet_nonprd = local.name_of_subnet_nonprd
  subnet_address_space_nonprd = local.subnet_address_space_nonprd
  depends_on = [ 
    module.general_module
  ]
}