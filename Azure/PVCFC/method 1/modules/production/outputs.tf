output "prd-vminfo" {
  value = azurerm_linux_virtual_machine.tf-prdlinux.private_ip_address
}