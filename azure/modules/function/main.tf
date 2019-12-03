resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "csye6225-service-plan"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name 
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "app_insights" {
  name                = "csye6225-terraform-insights"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  application_type    = "Web"
}

resource "azurerm_function_app" "func_app" {
  name                      = var.function_name 
  location                  = var.resource_group_location 
  resource_group_name       = var.resource_group_name 
  app_service_plan_id       = "${azurerm_app_service_plan.app_service_plan.id}"
  storage_connection_string = var.storage_connection_string
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.app_insights.instrumentation_key}"
  }
}
