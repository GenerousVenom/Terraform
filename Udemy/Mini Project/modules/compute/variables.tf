variable "resource_group_name" {
  type=string
  description = "This defines the name of the resource grp"
}

variable "location" {
  type=string
  description = "This defines the location of the resource grp"
}

variable "network_interface_name" {
  type = string
  description = "This defines the Network interface name"
}

variable "subnet_id" {
  type = string
  description = "This defines the Subnet id"
}

variable "public_ip_required" {
  type = bool
  description = "This requirement of the public IP"
  default = false
}

variable "windows_virtual_machine_name" {
  type = string
  description = "This defines the Virtual machine name"
}

variable "admin_username" {
  type = string
  description = "This defines the admin user for the virtual machine"
}

variable "admin_password" {
  type = string
  description = "This defines the admin password for the virtual machine"
}

variable "source_image_reference" {
  type = map
  description = "This defines the source image reference for the virtual machine"
}