resource "azurerm_public_ip" "tf-publicip" {
  count = var.number_of_machines
  name                = "tfpublicip${count.index}"
  resource_group_name = local.group_name
  location            = local.location
  allocation_method   = "Static"
  # TODO: zones = 
  tags = {
    environment = "Production"
  }

  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}
resource "azurerm_network_interface" "tf-nwinterface" {
  count = var.number_of_machines
  name                = "tfnetinterface${count.index}"
  location            = local.location
  resource_group_name = local.group_name
  ip_configuration {
    name                          = "ipconf${count.index}"
    subnet_id                     = azurerm_subnet.tf-subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-publicip[count.index].id
  }

  depends_on = [
    azurerm_resource_group.tf-rg,
    azurerm_subnet.tf-subnet,
    azurerm_public_ip.tf-publicip
  ]
}

resource "azurerm_windows_virtual_machine" "tf-winsrv2019" {
  count = var.number_of_machines
  name                = "tf-winsrv2019-${count.index}"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_D2a_v4"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.tf-keyvaultsec.value
  availability_set_id = azurerm_availability_set.tf-aset.id
  # TODO: zone = 
  network_interface_ids = [
    azurerm_network_interface.tf-nwinterface[count.index].id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_resource_group.tf-rg,
    azurerm_network_interface.tf-nwinterface,
    azurerm_key_vault_secret.tf-keyvaultsec
  ]
}

# output "virtualmachine_file" {
#   count = var.number_of_machines
#   value = "virtual machine",
#   value = azurerm_public_ip.tf-publicip.*.ip_address        //https://discuss.hashicorp.com/t/how-to-output-multiple-public-ips/8323
# }

# output "virtualmachine_output" {
#   value = azurerm_windows_virtual_machine.tf-winsrv2019[0].id
# }