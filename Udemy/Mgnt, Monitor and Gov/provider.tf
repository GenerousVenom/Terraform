terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = "fcf1d1dd-5b6c-4e77-a906-a6359dd287ed"
  subscription_id = "0da0b47d-2014-4004-8b29-2795334e34da"
  client_id       = "d2393fbe-e5c1-418a-8988-d6752d8ff7ea"
  client_secret   = "jyX8Q~gYGLhfaq8zVlHCAEQxQmtaeZbG97J9Xa3t"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true       # * For keyvault.tf file
    }
  }
}