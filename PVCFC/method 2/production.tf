#* Create network security group
resource "azurerm_network_security_group" "tf-netsecgrp-prd" {
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg[1])[0]}netsecgrp${split("rsg", var.name_of_rsg[1])[1]}"
  resource_group_name = var.name_of_rsg[0]

  security_rule {
    name                       = "AllowRDP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [ 
    azurerm_resource_group.tf-rg
  ]
}

#* Create Subnet
resource "azurerm_subnet" "tf-prdsubnet" {
  count                = length(var.name_of_subnet_prd)
  name                 = var.name_of_subnet_prd[count.index]
  resource_group_name  = var.name_of_rsg[1]
  virtual_network_name = "${split("rsg", var.name_of_rsg[1])[0]}vnet${split("rsg", var.name_of_rsg[1])[1]}"
  address_prefixes     = [var.subnet_address_space_prd[count.index]]
  depends_on = [ 
    azurerm_resource_group.tf-rg,
    azurerm_virtual_network.tf-vnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "tf-netsecgrpass-prd" {
  count                     = length(var.name_of_subnet_prd)
  subnet_id                 = azurerm_subnet.tf-prdsubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.tf-netsecgrp-prd.id
  depends_on = [ 
    azurerm_subnet.tf-prdsubnet,
    azurerm_network_security_group.tf-netsecgrp-prd
  ]
}

# resource "azurerm_public_ip" "tf-pubip-prolinux" {
#   name                = "pubip-prolinux"
#   resource_group_name = var.name_of_rsg[1]
#   location            = var.name_of_location
#   allocation_method   = "Static"
# }

#* Create Linux VM
resource "azurerm_network_interface" "tf-prdnwint" {
  name                = "prdlinux-nic"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[1]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-prdsubnet[0].id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.tf-pubip-prolinux.id
  }

  depends_on = [ 
    azurerm_subnet_network_security_group_association.tf-netsecgrpass-prd,
    # azurerm_public_ip.tf-pubip-prolinux
  ]
}

resource "azurerm_linux_virtual_machine" "tf-prdlinux" {
  name                = "Prd-Linux"
  resource_group_name = var.name_of_rsg[1]
  location            = var.name_of_location
  size                = "Standard_DS1_v2"
  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-prdnwint.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
