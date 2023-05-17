output "tfout-vnet" {
  value = azurerm_virtual_network.tf-virnet
}

output "tfout-subnet" {
  value = azurerm_subnet.tf-sub
}

output "test" {
  value = azurerm_subnet.tf-sub["web-subnet"].address_prefixes
}

output "abce" {
  value = "dflsdkfjsd"
}