variable "name_of_location" {
  type = string
}

variable "name_of_rsg" {
  type = list(string)
}

variable "name_of_vnet" {
  type = list(string)
}

variable "vnet_address_space" {
  type = list(string)
}

variable "name_of_tags" {
  type = map(string)
}