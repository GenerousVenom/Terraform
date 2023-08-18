resource "azurerm_monitor_action_group" "tf-monitorgrp-mgmt" {
  name                = "KMS_Budget"
  resource_group_name = var.name_of_rsg[0]
  short_name          = "KMS"
  tags = var.name_of_tags

  email_receiver {
    name          = "thinh.phung"
    email_address = "thinh.phung@svtech.com.vn"
  }

  depends_on = [ 
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_consumption_budget_resource_group" "tf-conbudgetrsg-mgmt" {
  name              = "tf-conbudgetrsg-mgmt"
  resource_group_id = azurerm_resource_group.tf-rg[0].id

  amount     = 1000
  time_grain = "Monthly"

  time_period {
    start_date = "2023-08-01T00:00:00Z"       # Must be first of the month
    end_date   = "2023-09-01T00:00:00Z"
  }

  filter {
    dimension {
      name = "ResourceId"
      values = [
        azurerm_monitor_action_group.tf-monitorgrp-mgmt.id,
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 50.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-mgmt.id,
    ]
  }

  notification {
    enabled        = true
    threshold      = 75.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-mgmt.id,
    ]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-mgmt.id,
    ]
  }
  
  depends_on = [ 
    azurerm_resource_group.tf-rg,
    azurerm_monitor_action_group.tf-monitorgrp-mgmt
  ]
}