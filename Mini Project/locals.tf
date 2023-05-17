locals {
  #* local variable for general folder
  resource_group_name="staging-grp"
  location="East Asia"

  #* local variable for networking folder
  virtual_network_name = "staging-network"
  virtual_network_address_space = "10.0.0.0/16"
  subnet_names = ["web-subnet", "db-subnet"]
  bastion_required = true
  network_security_group_name = {
    "web-nsg" = "web-subnet", 
    "db-nsg" = "db-subnet"
  }
  network_security_group_rules = [
    {
      id = 1,
      name = "AllowRDP"
      priority = "200",
      network_security_group_name = "web-nsg"
      destination_port_range = "3389"
      access = "Allow"
    },
    {
      id = 2,
      name = "AllowSSH"
      priority = "201",
      network_security_group_name = "web-nsg"
      destination_port_range = "22"
      access = "Allow"
    },
    {
      id = 3,
      name = "AllowHTTP"
      priority = "202",
      network_security_group_name = "web-nsg"
      destination_port_range = "80"
      access = "Allow"
    },
    { #* To public the application from VS
      id = 4,
      name = "AllowPublicApplicationfromVS"
      priority = "203",
      network_security_group_name = "web-nsg"
      destination_port_range = "8172"
      access = "Allow"
    }
  ]

  #* local variable for compute folder
  network_interface_name = "db-interface"
  subnet_id = module.networking_module.tfout-subnet["db-subnet"].id
  windows_virtual_machine_name = "tfdbwinvm2019"
  admin_user = "dbuser"
  admin_password = "123qwe!@#QWE"
  source_image_reference = {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2019"
    sku       = "sqldev"
    version   = "15.0.220510"
  }

  #* local variable for storage folder
}