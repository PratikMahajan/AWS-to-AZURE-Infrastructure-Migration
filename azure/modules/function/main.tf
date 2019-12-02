resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name 
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "test" {
  name                = "test-terraform-insights"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  application_type    = "Web"
}

resource "azurerm_function_app" "example" {
  name                      = var.function_name 
  location                  = var.resource_group_location 
  resource_group_name       = var.resource_group_name 
  app_service_plan_id       = "${azurerm_app_service_plan.example.id}"
  storage_connection_string = var.storage_connection_string
  
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.test.instrumentation_key}"
  }
}
