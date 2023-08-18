resource "azurerm_storage_account" "tf-stracc" {
  name                     = "tfstraccthinhphung"
  resource_group_name      = local.group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_storage_container" "tf-strcon" {
  name                  = "tfstrcon"
  storage_account_name  = azurerm_storage_account.tf-stracc.name
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.tf-stracc
  ]
}

#* Upload file to created blob
resource "azurerm_storage_blob" "tf-strblob" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.tf-stracc.name
  storage_container_name = azurerm_storage_container.tf-strcon.name
  type                   = "Block"
  source                 = "IIS_Config.ps1"
  depends_on = [
    azurerm_storage_account.tf-stracc,
    azurerm_storage_container.tf-strcon
  ]
}

# * Reference: https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows#property-values
resource "azurerm_virtual_machine_extension" "tf-vmext" {
#  count = var.number_of_machines
  name                 = "tfvmext"
#  virtual_machine_id   = azurerm_windows_virtual_machine.tf-winsrv2019[count.index].id
  virtual_machine_id   = azurerm_windows_virtual_machine.tf-winsrv2019[0].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_windows_virtual_machine.tf-winsrv2019
  ]

  settings = <<SETTINGS
    {
      "fileUris": ["https://${azurerm_storage_account.tf-stracc.name}.blob.core.windows.net/tfstrcon/IIS_Config.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File IIS_Config.ps1"
    }
SETTINGS
}

output "customscript_output" {
  value = "Customscript file"
}