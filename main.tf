provider "azurerm" {
  features {}
  subscription_id = "a98d0e19-0c0e-4a5b-91ac-c6923c6331bc"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "AzureclassAssignThu"
  location = "East US"
}

# Create App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = "jenkins-app-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S1"
  os_type             = "Linux"
}

# Create App Service for .NET 8 Web API
resource "azurerm_linux_web_app" "webapp" {
  name                = "jenkins-yd-webapp"
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
