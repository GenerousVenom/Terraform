locals {
  #* Common Variables
  name_of_location = "Southeast Asia"

  name_of_rsg = ["sg-sea-dmgmt-rsg-01", "sg-sea-prd-rsg-01", "sg-sea-nonprd-rsg-01"]

  #* Virtual Network Variables
  vnet_address_space = ["10.80.0.0/22", "10.80.4.0/22", "10.80.8.0/22"]

  #* Variables for management zone
  name_of_subnet_dmgmt = ["GatewaySubnet", "AzureBastionSubnet", "sg-sea-Jumpboxsnet-sn"]
  subnet_address_space_dmgmt = ["10.80.0.0/26", "10.80.1.0/26", "10.80.2.0/26"]
  onpre_public_ip_dmgmt = "113.161.221.2"
  onpre_subnet_space_dmgmt = "10.86.0.0/16"
  name_of_stracc = "thterrastracc"
  name_of_keyvault = "tfkeyvaultsecthinhphung2"

  #* Variables for production zone
  name_of_subnet_prd = ["sg-sea-prd-subnet-01"]
  subnet_address_space_prd = ["10.80.4.0/24"]

  #* Variables for nonproduction zone
  name_of_subnet_nonprd = ["sg-sea-nonprd-subnet-01"]
  subnet_address_space_nonprd = ["10.80.8.0/24"]
}