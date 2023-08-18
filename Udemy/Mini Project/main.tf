module "general_module"{
  source="./modules/general"
  resource_group_name = local.resource_group_name
  location = local.location
}

module "networking_module"{
  source = "./modules/networking"
  resource_group_name = local.resource_group_name
  location = local.location
  virtual_network_name = local.virtual_network_name
  virtual_network_address_space = local.virtual_network_address_space
  subnet_names = local.subnet_names
  # bastion_required = local.bastion_required
  bastion_required = local.bastion_required
  network_security_group_name = local.network_security_group_name
  network_security_group_rules = local.network_security_group_rules

  depends_on = [
    module.general_module
  ]
}

module "compute_module" {
  source = "./modules/compute"
  resource_group_name = local.resource_group_name
  location = local.location
  network_interface_name = local.network_interface_name
#  subnet_id = module.networking_module.tfout-subnet["db-subnet"].id
  subnet_id = local.subnet_id
  windows_virtual_machine_name = local.windows_virtual_machine_name
  admin_username = local.admin_user
  admin_password = local.admin_password
  source_image_reference = local.source_image_reference
  
  depends_on = [
    module.networking_module
  ]
}

resource "azurerm_mssql_virtual_machine" "tf-mssqlvm" {
  virtual_machine_id               = module.compute_module.tfout-windowvm.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_update_username = "sqluser"
  sql_connectivity_update_password = "123qwe!@#QWE"
  sql_connectivity_type            = "PRIVATE"

  depends_on = [
    module.compute_module
  ]
}