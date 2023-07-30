resource "azurerm_public_ip" "tf-pubip-bas-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg)[0]}pubip-bas${split("rsg", var.name_of_rsg)[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "tf-bas-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg)[0]}bas${split("rsg", var.name_of_rsg)[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg

  ip_configuration {
    name                 = "${split("rsg", var.name_of_rsg)[0]}ipconf-bas${split("rsg", var.name_of_rsg)[1]}"
    subnet_id            = azurerm_subnet.tf-dmgmtsub[1].id
    public_ip_address_id = azurerm_public_ip.tf-pubip-bas-dmgmt.id
  }

  depends_on = [ 
    azurerm_subnet.tf-dmgmtsub
  ]
}