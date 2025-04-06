variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "a98d0e19-0c0e-4a5b-91ac-c6923c6331bc"
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-jenkins"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "App Service Plan Name"
  type        = string
  default     = "jenkins-app-service-plan"
}

variable "sku_name" {
  description = "App Service Plan SKU"
  type        = string
  default     = "S1"
}

variable "os_type" {
  description = "Operating System Type"
  type        = string
  default     = "Linux"
}

variable "web_app_name" {
  description = "Web App Name"
  type        = string
  default     = "jenkins-yd-webapp"
}

variable "dotnet_version" {
  description = "Dotnet Runtime Version"
  type        = string
  default     = "8.0"
}
