terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
}

provider "vsphere" {
  # Configuration options
  vsphere_server = var.vsphere_server
  user = var.vsphere_user
  password = var.vsphere_password
  allow_unverified_ssl = true
}