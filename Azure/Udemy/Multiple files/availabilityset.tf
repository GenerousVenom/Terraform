resource "azurerm_availability_set" "tf-aset" {
  name                = "tfaset"
  location            = local.location
  resource_group_name = local.group_name
  platform_fault_domain_count = 1
  platform_update_domain_count = 1
  tags = {
    environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

output "availabilityset-output" {
  value = "availabilityset file"
}