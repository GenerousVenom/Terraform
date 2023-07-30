resource "azurerm_network_interface" "tf-dbnetint" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "dbipconf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = try(azurerm_public_ip.tf-dbpubip[0].id, null)
  }

  depends_on = [
    azurerm_public_ip.tf-dbpubip
  ]
}

resource "azurerm_public_ip" "tf-dbpubip" {
  count = var.public_ip_required ? 1:0 
  name = "tfdbpubip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
}

resource "azurerm_windows_virtual_machine" "tf-dbwinvm2019" {
  name                = var.windows_virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.tf-dbnetint.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    # publisher = "MicrosoftWindowsServer"
    # offer     = "WindowsServer"
    # sku       = "2019-Datacenter"
    # version   = "latest"
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  depends_on = [
    azurerm_network_interface.tf-dbnetint
  ]
}