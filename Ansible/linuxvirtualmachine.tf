variable "number_of_linux_machines" {
  type = number
}

#* Create one public ip address for ansible master
resource "azurerm_public_ip" "tf-linuxpublicip" {
  name                = "tflinuxpublicip"
  resource_group_name = local.group_name
  location            = local.location
  allocation_method   = "Static"
  # TODO: zones = 
  tags = {
    environment = "Production"
  }

  depends_on = [
    azurerm_resource_group.tf-resourcegrp
  ]
}

resource "azurerm_network_interface" "tf-networkinterfaceansible" {
  name                = "tfnetworkinterface0"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "internal0"
    subnet_id                     = azurerm_subnet.tf-sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-linuxpublicip.id
  }
  
  depends_on = [
    azurerm_resource_group.tf-resourcegrp,
    azurerm_subnet.tf-sub
  ]
}

resource "azurerm_linux_virtual_machine" "tf-linuxvmansible" {
  name                = "tf-linuxU18-0"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  disable_password_authentication = "false"
  admin_password = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-networkinterfaceansible.id
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

  depends_on = [
    azurerm_network_interface.tf-networkinterfaceansible
  ]
}

resource "azurerm_network_interface" "tf-networkinterface" {
  count = var.number_of_linux_machines - 1
  name                = "tfnetworkinterface${count.index + 1}"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "internal${count.index + 1}"
    subnet_id                     = azurerm_subnet.tf-sub.id
    private_ip_address_allocation = "Dynamic"
  }
  
  depends_on = [
    azurerm_resource_group.tf-resourcegrp,
    azurerm_subnet.tf-sub
  ]
}

resource "azurerm_linux_virtual_machine" "tf-linuxvm" {
  count = var.number_of_linux_machines - 1
  name                = "tf-linuxU18-${count.index + 1}"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  disable_password_authentication = "false"
  admin_password = "123qwe!@#QWE"
  network_interface_ids = [
    azurerm_network_interface.tf-networkinterface[count.index].id
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

  depends_on = [
    azurerm_network_interface.tf-networkinterface
  ]
}

resource "null_resource" "tf-file-ip" {
  count = var.number_of_linux_machines - 1
  provisioner "local-exec" {
    command = "echo server${count.index + 1} ansible_host=${azurerm_network_interface.tf-networkinterface[count.index].private_ip_address} ansible_connection=ssh ansible_user=adminuser ansible_password=${azurerm_linux_virtual_machine.tf-linuxvm[count.index].admin_password} >> inventory.txt"
  }

  depends_on = [
    azurerm_linux_virtual_machine.tf-linuxvm
  ]
  
}

resource "null_resource" "tf-addfile" {
  #* Copy ansible file to VM
  provisioner "file" {
    source = "inventory.txt"
    destination = "/home/adminuser/inventory.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install ansible -y"
    ]
  }

  connection {
    type = "ssh"
    user = "adminuser"
    password = "123qwe!@#QWE"
    host = azurerm_public_ip.tf-linuxpublicip.ip_address
  }

  depends_on = [
    null_resource.tf-file-ip
  ]
}

# resource "null_resource" "tf-file-prefixabc" {
#   provisioner "local-exec" {
#     command = "echo final >> inventory.txt"
#   }
# }

output "tf-linuxpublic-ip" {
  value = azurerm_public_ip.tf-linuxpublicip.ip_address
}