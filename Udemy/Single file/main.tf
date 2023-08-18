terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = "e23f49f9-fc5b-46ed-b5e6-6606e29e0b14"
  subscription_id = "f9a92d15-34b7-4665-b1d1-39e1a39c1d15"
  client_id       = "f8587ba8-3128-4b2c-862a-7521de3ec366"
  client_secret   = "LCp8Q~IqWzjMrlexdzM-pGkv3IVEEoW~s3K6raQE"
  features {}
}

locals {
  location = "Southeast Asia"
  group_name = "tf-rg"
}

#Create a resource grp
resource "azurerm_resource_group" "tf-rg" {
  name     = local.group_name
  location = local.location                     #https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#geographies
}

resource "azurerm_network_security_group" "tf-netsecgrp" {
  name                = "tfnetsecgrp"
  location            = local.location
  resource_group_name = local.group_name
  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
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
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "tf-virnet" {
  name                = "tfvirnet"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = local.group_name
}

resource "azurerm_subnet" "tf-subnet" {
  name                 = "tfsubnet"
  resource_group_name  = local.group_name
  virtual_network_name = azurerm_virtual_network.tf-virnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [
    azurerm_virtual_network.tf-virnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "tf-nwsecgrpass" {
  subnet_id = azurerm_subnet.tf-subnet.id
  network_security_group_id = azurerm_network_security_group.tf-netsecgrp.id
  depends_on = [
    azurerm_subnet.tf-subnet,
    azurerm_network_security_group.tf-netsecgrp
  ]
}

resource "azurerm_public_ip" "tf-publicip" {
  name                = "tfpublicip"
  resource_group_name = local.group_name
  location            = local.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_interface" "tf-netinterface" {
  name                = "tfnetinterface"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.tf-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-publicip.id
  }
  depends_on = [
    azurerm_public_ip.tf-publicip
  ]
}

resource "azurerm_windows_virtual_machine" "tf-winsrv2019" {
  name                = "tf-winsrv2019"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_D2ls_v5"
  admin_username      = "adminuser"
  admin_password      = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-netinterface.id,
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
    azurerm_network_interface.tf-netinterface,
  ]
}

resource "azurerm_managed_disk" "tf-manageddisk" {
  name                 = "tfmanageddisk"
  location             = local.location
  resource_group_name  = local.group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "16"
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.tf-manageddisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.tf-winsrv2019.id
  lun                = "10"
  caching            = "ReadWrite" 
  depends_on = [
    azurerm_managed_disk.tf-manageddisk,
    azurerm_windows_virtual_machine.tf-winsrv2019
  ]
}

// To generate a private key
resource "tls_private_key" "tf-linuxkey" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "local_file" "tf-linuxpemkey" {
  filename = "linuxkey.pem"
  content = tls_private_key.tf-linuxkey.private_key_pem
  depends_on = [
    tls_private_key.tf-linuxkey
  ]
}
resource "local_file" "tf-linuxpubkey" {
  filename = "linuxpubkey.pem"
  content = tls_private_key.tf-linuxkey.public_key_openssh
  depends_on = [
    tls_private_key.tf-linuxkey
  ]
}

resource "azurerm_public_ip" "tf-linuxpublicip" {
  name                = "tflinuxpublicip"
  resource_group_name = local.group_name
  location            = local.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "tf-linuxnetinterface" {
  name                = "tflinuxnetinterface"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "linuxipconfig"
    subnet_id                     = azurerm_subnet.tf-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-linuxpublicip.id
  }
  depends_on = [
    azurerm_public_ip.tf-linuxpublicip
  ]
}

resource "azurerm_linux_virtual_machine" "tf-linux" {
  name                = "tf-U16"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.tf-linuxnetinterface.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.tf-linuxkey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.tf-netinterface,
    tls_private_key.tf-linuxkey
  ]
}