resource "azurerm_log_analytics_workspace" "tf-analyworkspace" {
  name                = "tf-thinh-analyworkspace"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_virtual_machine_extension" "tf-winvmext" {
  name                 = "tf-winvmext"
  virtual_machine_id   = var.winvm_id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
    {
        "workspaceId": "${azurerm_log_analytics_workspace.tf-analyworkspace.id}"
    }
SETTINGS
    protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.tf-analyworkspace.primary_shared_key}"
    }
PROTECTED_SETTINGS
  depends_on = [
    azurerm_log_analytics_workspace.tf-analyworkspace
  ]
}

resource "azurerm_log_analytics_datasource_windows_event" "tf-winevent" {
  name                = "tf-winevent"
  resource_group_name = var.name_of_rsg
  workspace_name      = azurerm_log_analytics_workspace.tf-analyworkspace.name
  event_log_name      = "System"
  event_types         = ["Information"]
  depends_on = [
    azurerm_log_analytics_workspace.tf-analyworkspace
  ]
}