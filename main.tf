# This block tells Terraform we need the "azurerm" provider for Azure.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Terraform will use the Azure CLI login automatically.
provider "azurerm" {
  features {}
}

# This is creates an Azure Resource Group named "tf-lab-rg".
resource "azurerm_resource_group" "rg" {
  name     = "tf-lab-rg"
  location = "East US" # You can change this to a region near you.
}
