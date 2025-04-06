variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "a98d0e19-0c0e-4a5b-91ac-c6923c6331bc" # Your Azure subscription ID
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "python-webapp-rg" # Updated name for the resource group
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US" # Preferred Azure region
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "python-app-service-plan" # Updated for the Python App Service Plan
}

variable "os_type" {
  description = "Operating System Type for App Service"
  type        = string
  default     = "Linux" # Ensure it is set to Linux for Python
}

variable "sku_name" {
  description = "Pricing Tier for App Service Plan"
  type        = string
  default     = "S1" # Pricing tier remains the same
}

variable "app_service_name" {
  description = "Name of the Web App"
  type        = string
  default     = "python-webapp" # Updated for the Python web application
}

variable "python_version" {
  description = "Python Runtime Version"
  type        = string
  default     = "3.9" # Specify the desired Python runtime version
}

variable "startup_file" {
  description = "Startup file for the Python Web App"
  type        = string
  default     = "PythAzureApI_.py" 
}