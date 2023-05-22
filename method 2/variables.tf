variable "name_of_location" {
  type = string
}

variable "name_of_rsg" {
  type = list(string)
}

variable "vnet_address_space" {
  type = list(string)
}

#* Variable for management zone
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

#* Variable for production zone
variable "name_of_subnet_prd" {
  type = list(string)
}

variable "subnet_address_space_prd" {
  type = list(string)
}


# variable "number_of_subnets" {
#   type = number
#   default = 2
#   validation {
#     condition = var.number_of_subnets < 5
#     error_message = "The number of subnets must be less than 5"
#   }
# }

# variable "number_of_machines" {
#   type = number
#   default = 1
# }