resource "azurerm_monitor_activity_log_alert" "tf-logalert" {
  name                = "tf-logalert"
  resource_group_name = var.name_of_rsg
  scopes              = [var.winvm_id]
  description         = "This alert will monitor a specific VM"

  criteria {    # https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-categories
    resource_id    = var.winvm_id
    operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"  # https://stackoverflow.com/questions/69375984/what-should-be-the-operation-name-for-creating-a-monitor-alert-using-terraform
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.tf-actiongrp.id
  }
}