output "tf_network_output" {
  value = azurerm_subnet.tf-subnet.*.address_prefixes
}

output "tf_virtualmachinepubip_output" {
  value = azurerm_public_ip.tf-publicip.*.ip_address
}

output "tf_virtualmachineprivateip_output" {
  value = azurerm_network_interface.tf-nwinterface.*.ip_configuration
}

output "tf_linuxvm_output" {
  value = azurerm_public_ip.tf-linuxpublicip.*.ip_address 
}