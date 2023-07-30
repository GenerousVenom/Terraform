variable "name_of_location" {
  type = string
}

variable "name_of_rsg" {
  type = string
}

variable "name_of_subnet_dmgmt" {
  type = list(string)
}

variable "subnet_address_space_dmgmt" {
  type = list(string)
}

variable "name_of_stracc" {
  type = string
}

variable "name_of_keyvault" {
  type = string
}

variable "onpre_public_ip_dmgmt" {
  type = string
}

variable "onpre_subnet_space_dmgmt" {
  type = string
}