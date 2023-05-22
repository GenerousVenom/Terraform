resource "azurerm_resource_group" "tf-rg" {
  count     = length(var.name_of_rsg)
  name      = var.name_of_rsg[count.index]
  location  = var.name_of_location
}

resource "azurerm_virtual_network" "tf-vnet" {
  count               = length(var.name_of_rsg)
  location            = var.name_of_location
  name                = "${split("rsg", var.name_of_rsg[count.index])[0]}vnet${split("rsg", var.name_of_rsg[count.index])[1]}" 
  resource_group_name = var.name_of_rsg[count.index]
  address_space       = [var.vnet_address_space[count.index]]
  depends_on = [ 
    azurerm_resource_group.tf-rg
  ]
}

#* Creating DDoS Protection
resource "azurerm_network_ddos_protection_plan" "tf-nwddosproplan-dmgmt" {
  name                = "${split("rsg", var.name_of_rsg[0])[0]}nwddosproplan${split("rsg", var.name_of_rsg[0])[1]}"
  location            = var.name_of_location
  resource_group_name = var.name_of_rsg[0]
}

#* Creating Governance
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
}

#* Creating Key vault
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "tf-keyvault-dmgmt" {
  name                        = "${split("rsg", var.name_of_rsg[0])[0]}keyvault${split("rsg", var.name_of_rsg[0])[1]}"
  location                    = var.name_of_location
  resource_group_name         = var.name_of_rsg[0]
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "Delete", "Purge"
    ]

    key_permissions = [
      "Get", "Delete", "Purge", "Create"
    ]
  }
}


#* Peering configuration from 1
resource "azurerm_virtual_network_peering" "tf-vnet-peer1to2-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer1to2${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[0]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[1].id
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer1to3-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer1to3${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[0]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[2].id
}

#* Peering configuration from 2
resource "azurerm_virtual_network_peering" "tf-vnet-peer2to1-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer2to1${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[1]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[0].id
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer2to3-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer2to3${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[1]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[1].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[2].id
}

#* Peering configuration from 3
resource "azurerm_virtual_network_peering" "tf-vnet-peer3to1-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer3to1${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[2]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[0].id
}

resource "azurerm_virtual_network_peering" "tf-vnet-peer3to2-dmgmt" {
  name                      = "${split("rsg", var.name_of_rsg[0])[0]}peer3to2${split("rsg", var.name_of_rsg[0])[1]}"
  resource_group_name       = var.name_of_rsg[2]
  virtual_network_name      = azurerm_virtual_network.tf-vnet[2].name
  remote_virtual_network_id = azurerm_virtual_network.tf-vnet[1].id
}

output "output_main_file" {
  value = length(var.name_of_rsg)
}