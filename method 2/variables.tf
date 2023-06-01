#* Variables for common resources
variable "name_of_location" {
  type = string
}
variable "name_of_rsg" {
  type = list(string)
}
variable "vnet_address_space" {
  type = list(string)
}


#* Variables for management zone
variable "name_of_subnet_dmgmt" {
  type = list(string)
}
variable "subnet_address_space_dmgmt" {
  type = list(string)
}
variable "onpre_public_ip_dmgmt" {
  type = string
}
variable "onpre_subnet_space_dmgmt" {
  type = string
}
variable "name_of_stracc" {
  type = string
}
variable "name_of_keyvault" {
  type = string
}

#* Variable for production zone
variable "name_of_subnet_prd" {
  type = list(string)
}
variable "subnet_address_space_prd" {
  type = list(string)
}

#* Variable for nonproduction zone
variable "name_of_subnet_nonprd" {
  type = list(string)
}
variable "subnet_address_space_nonprd" {
  type = list(string)
}