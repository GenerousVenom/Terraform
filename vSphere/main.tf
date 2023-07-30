module "clonetemp" {
  source = "./modules/clonetemp"
  resource_pool_id = data.vsphere_compute_cluster.tf-vsphere-clus.resource_pool_id
  datastore_id = data.vsphere_datastore.tf-vsphere-ds.id
  network_id = data.vsphere_network.tf-vsphere-nw.id
  u22_temp_guest_id = data.vsphere_virtual_machine.tf-template.guest_id
  u22_temp_id = data.vsphere_virtual_machine.tf-template.id
  depends_on = [ 
    data.vsphere_compute_cluster.tf-vsphere-clus,
    data.vsphere_datastore.tf-vsphere-ds,
    data.vsphere_network.tf-vsphere-nw
  ]
}