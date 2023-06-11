resource "azurerm_public_ip" "tf-pubip" {
  name                = "tf-pubip"
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "tf-netint-win" {
  name                = "tf-netint-win"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-pubip.id
  }
}

resource "azurerm_windows_virtual_machine" "tf-winvm" {
  name                = "tf-winvm"
  resource_group_name = var.name_of_rsg
  location            = var.name_of_location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-netint-win.id,
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
}

# resource "azurerm_management_lock" "tf-mgnt-lock" {
#   name       = "tf-mgnt-lock"
#   scope      = azurerm_windows_virtual_machine.tf-winvm.id
#   lock_level = "ReadOnly"
#   notes      = "No changes can be made to the virtual machine"
#   depends_on = [ 
#     azurerm_windows_virtual_machine.tf-winvm
#   ]
# }