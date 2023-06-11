resource "azurerm_monitor_action_group" "tf-actiongrp" {
  name                = "tf-thinh-acgrp"
  resource_group_name = var.name_of_rsg
  short_name          = "acgrp"

  email_receiver {
    name          = "thinh.phung"
    email_address = "thinh.phung@svtech.com.vn"
    use_common_alert_schema = true        # Enables or disables the common alert schema.
  }
}