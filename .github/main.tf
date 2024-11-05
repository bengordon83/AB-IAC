provider "azurerm" {
  features {}
}

terraform {
  backend "remote" {
    organization = "ab-inbev"
    workspaces {
      name = "deploy-app-service"
    }
  }
}

# Resource group for the Azure App Service
resource "azurerm_resource_group" "rg" {
  name     = "example-resource-group"
  location = "East US"
}

# App Service Plan for hosting the Azure App Service
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Azure App Service
resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
