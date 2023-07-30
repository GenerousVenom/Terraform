resource "azurerm_monitor_metric_alert" "tf-metricalert" {
  name                = "tf-metricalert"
  resource_group_name = var.name_of_rsg
  scopes              = [var.winvm_id]
  description         = "Action will be triggered when CPU count is greater than 50."

  criteria {  # https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 50
  }

  frequency = "PT5M"
  window_size = "PT15M"

  action {
    action_group_id = azurerm_monitor_action_group.tf-actiongrp.id
  }
}