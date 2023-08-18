variable "number_of_subnets" {
  type = number
  default = 2
  validation {
    condition = var.number_of_subnets < 5
    error_message = "The number of subnets must be less than 5"
  }
}

variable "number_of_machines" {
  type = number
  default = 1
}