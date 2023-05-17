resource "azurerm_network_interface" "tf-webnetint" {
  name                = "tfwebnetint"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "webipconf"
    subnet_id                     = module.networking_module.tfout-subnet["web-subnet"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-webpubip.id
  }

  depends_on = [
    module.general_module.tfout-resourcegroup,
    module.networking_module.tfout-subnet,
    azurerm_public_ip.tf-webpubip
  ]
}

resource "azurerm_public_ip" "tf-webpubip" {
  name = "tfwebpubip"
  location = local.location
  resource_group_name = local.resource_group_name
  allocation_method = "Static"
  
  depends_on = [
    module.general_module.tfout-resourcegroup
  ]
}

resource "azurerm_windows_virtual_machine" "tf-webwinvm2019" {
  name                = "tfwebwinvm2019"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D1"
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-webnetint.id
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
    module.general_module.tfout-resourcegroup,
    azurerm_network_interface.tf-webnetint
  ]
}