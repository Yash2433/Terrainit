provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S1"
  os_type             = "Linux"
}

# .NET 8 Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true

    application_stack {
      dotnet_version = "8.0"
    }
  }
}
