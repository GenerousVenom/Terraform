locals {
  vm1 = {
    name_of_vm      = "Thinh_CloneTemp_1"
    num_cpus        = 2
    memory          = 4096
    disk_size       = "100"
    name_of_host    = "Ubuntu22"
    name_of_domain  = "Ubuntu22"
    name_of_folder  = "Thinh.Phung - VM"
    ipv4_address    = "192.168.22.178"
    ipv4_netmask    = 24
    ipv4_gateway    = "192.168.22.1"
    dns_server_list = "192.168.22.91"
  }

  vm2 = {
    name_of_vm      = "Thinh_CloneTemp_2"
    num_cpus        = 2
    memory          = 4096
    disk_size       = "100"
    name_of_host    = "Ubuntu22"
    name_of_domain  = "Ubuntu22"
    name_of_folder  = "Thinh.Phung - VM"
    ipv4_address    = "192.168.22.179"
    ipv4_netmask    = 24
    ipv4_gateway    = "192.168.22.1"
    dns_server_list = "192.168.22.91"
  }
}