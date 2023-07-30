resource "azurerm_resource_group" "tf-resourcegrp" {
  name = var.resource_group_name
  location = var.location
}