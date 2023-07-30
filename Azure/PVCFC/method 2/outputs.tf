output "output_test" {
  value = length(var.name_of_rsg)
}

#* Production Output
output "prd-vminfo" {
  value = azurerm_linux_virtual_machine.tf-prdlinux.private_ip_address
}

#* Nonproduction Output
output "nonprd-vminfo" {
  value = azurerm_linux_virtual_machine.tf-nonprdlinux.private_ip_address
}