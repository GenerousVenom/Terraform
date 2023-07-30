resource "azurerm_public_ip" "tf-linuxpublicip" {
  count = var.number_of_machines
  name                = "tflinuxpublicip${count.index}"
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

resource "azurerm_network_interface" "tf-linuxnwinterface" {
  count = var.number_of_machines
  name                = "tflinuxnwinterface${count.index}"
  location            = local.location
  resource_group_name = local.group_name

  ip_configuration {
    name                          = "internal${count.index}"
    subnet_id                     = azurerm_subnet.tf-subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-linuxpublicip[count.index].id
  }
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

data "template_file" "tf-cloudinit" {
  template = file("nginx.sh")
}

resource "azurerm_linux_virtual_machine" "tf-linuxvm" {
  count = var.number_of_machines
  name                = "tf-linuxU18-${count.index}"
  resource_group_name = local.group_name
  location            = local.location
  size                = "Standard_D2a_v4"
  admin_username      = "adminuser"
  custom_data = base64encode(data.template_file.tf-cloudinit.rendered)
  # admin_password      = azurerm_key_vault_secret.tf-keyvaultsec.value
  network_interface_ids = [
    azurerm_network_interface.tf-linuxnwinterface[count.index].id
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
    sku       = "18.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_resource_group.tf-rg,
    azurerm_network_interface.tf-nwinterface,
    azurerm_key_vault_secret.tf-keyvaultsec,
    tls_private_key.tf-linuxkey
  ]
}

# output "linuxvm_file" {
#   # count = var.number_of_machines
#   # value = "virtual machine",
#   value = "Linux virtual machine output"
# }

# output "linuxvm_ip" {
#   value = azurerm_public_ip.tf-linuxpublicip.*.ip_address 
# }