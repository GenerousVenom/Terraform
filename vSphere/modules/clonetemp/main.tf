resource "vsphere_virtual_machine" "tf-vsphere-vm" {
  for_each = {
    "vm1" = local.vm1
    "vm2" = local.vm2
  }
  name = each.value.name_of_vm
  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  folder = each.value.name_of_folder

  num_cpus = each.value.num_cpus
  memory   = each.value.memory
  guest_id = var.u22_temp_guest_id
  
  network_interface {
    network_id = var.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label = each.value.name_of_vm
    size = each.value.disk_size
    thin_provisioned = true
  }

  clone {
    template_uuid = var.u22_temp_id
    customize {
      linux_options {
        host_name = each.value.name_of_host
        domain = each.value.name_of_domain
      }
      network_interface {
        ipv4_address = each.value.ipv4_address
        ipv4_netmask = each.value.ipv4_netmask
      }
      ipv4_gateway = each.value.ipv4_gateway
      dns_server_list = [each.value.dns_server_list]
    }
  }
}