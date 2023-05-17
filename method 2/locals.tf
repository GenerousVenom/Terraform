locals {
  #* Common Variables
  name_of_location = "Southeast Asia"

  # name_of_rsg = [ "${substr(split(" ", var.name_of_country)[0], 0, 1)}${substr(split(" ", var.name_of_country)[1], 0, 1)}-${substr(split(" ", var.name_of_location)[0], 0, 1)}${substr(split(" ", var.name_of_location)[1], 0, 1)}-dmgmt-rsg-01", 
  #                 "${substr(split(" ", var.name_of_country)[0], 0, 1)}${substr(split(" ", var.name_of_country)[1], 0, 1)}-${substr(split(" ", var.name_of_location)[0], 0, 1)}${substr(split(" ", var.name_of_location)[1], 0, 1)}-prd-rsg-01", 
  #                 "${substr(split(" ", var.name_of_country)[0], 0, 1)}${substr(split(" ", var.name_of_country)[1], 0, 1)}-${substr(split(" ", var.name_of_location)[0], 0, 1)}${substr(split(" ", var.name_of_location)[1], 0, 1)}-nonpro-rsg-01"]
  name_of_rsg = ["sg-sea-dmgmt-rsg-01", "sg-sea-prd-rsg-01", "sg-sea-nonprd-rsg-01"]

  #* Virtual Network Variables
  vnet_address_space = ["10.80.0.0/22", "10.80.4.0/22", "10.80.5.0/22"]

  #* Subnet Variables
  name_of_subnet_dmgmt = ["GatewaySubnet", "sg-sea-Jumpboxsnet-sn", "sg-sea-dmgmt-bastionsnet-sn"]
  subnet_address_space_dmgmt = ["10.80.0.0/26", "10.80.11.0/24", "10.80.1.0/26"]

  name_of_subnet_prd = ["sg-sea-prd-vnet-01"]
  subnet_address_space_prd = ["10.80.11.0/24"]
}