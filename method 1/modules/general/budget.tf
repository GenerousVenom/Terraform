resource "azurerm_monitor_action_group" "tf-monitorgrp-dmgmt" {
  name                = "Thinh_Budget"
  resource_group_name = var.name_of_rsg[0]
  short_name          = "Thinh-Budget"

  email_receiver {
    name          = "thinh"
    email_address = "thinh.phung@svtech.com.vn"
  }

  email_receiver {
    name          = "test"
    email_address = "test@svtech.com.vn"
  }
}

resource "azurerm_consumption_budget_resource_group" "tf-conbudgetrsg-dmgmt" {
  name              = "${split("rsg", var.name_of_rsg[0])[0]}conbudgetrsg${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_id = azurerm_resource_group.tf-rg[0].id

  amount     = 2000
  time_grain = "Monthly"

  time_period {
    start_date = "2023-06-01T00:00:00Z"
    end_date   = "2025-04-06T00:00:00Z"
  }

  filter {
    dimension {
      name = "ResourceId"
      values = [
        azurerm_monitor_action_group.tf-monitorgrp-dmgmt.id,
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 10.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-dmgmt.id,
    ]
  }

  notification {
    enabled        = true
    threshold      = 20.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-dmgmt.id,
    ]
  }

  notification {
    enabled        = true
    threshold      = 50.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-dmgmt.id,
    ]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.tf-monitorgrp-dmgmt.id,
    ]
  }

  depends_on = [ 
    azurerm_resource_group.tf-rg
  ]
}