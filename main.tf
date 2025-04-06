provider "azurerm" {
  features {}
  subscription_id = "a98d0e19-0c0e-4a5b-91ac-c6923c6331bc"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-jenkins"
  location = "East US"
}

# Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "yashappserviceplan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku_name = "S1"
  os_type  = "Linux"
}

# Create App Service for Jenkins
resource "azurerm_linux_web_app" "jenkins" {
  name                = "jenkins-yd-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true

    application_stack {
      docker_image_name = "jenkins/jenkins:lts"
    }
  }
}


