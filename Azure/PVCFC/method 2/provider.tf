terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = "Your Tenant ID"
  subscription_id = "Your Subscription ID"
  client_id       = "Your Application client ID"
  client_secret   = "Your Application Secrect Key"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true       # * For keyvault.tf file
    }
  }


  # skip_provider_registration = "true"
  # features {
  #   key_vault {
  #     purge_soft_delete_on_destroy = true
  #   }
  # }
}
