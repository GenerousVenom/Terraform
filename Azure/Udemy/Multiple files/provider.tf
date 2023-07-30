terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = "e23f49f9-fc5b-46ed-b5e6-6606e29e0b14"
  subscription_id = "f9a92d15-34b7-4665-b1d1-39e1a39c1d15"
  client_id       = "f8587ba8-3128-4b2c-862a-7521de3ec366"
  client_secret   = "LCp8Q~IqWzjMrlexdzM-pGkv3IVEEoW~s3K6raQE"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true       # * For keyvault.tf file
    }
  }
}