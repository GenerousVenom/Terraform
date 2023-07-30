variable "vsphere_user" {
  type = string
  default = "Your user"
}

variable "vsphere_password" {
  type = string
  sensitive = true
  default = "Your password"
}

variable "vsphere_server" {
  type = string
  default = "Your server address"
}