output "insights" {
  description = "configuration for applications insights"
  value       = azurerm_application_insights.this
}

output "api_keys" {
  description = "api keys for applications insights"
  value       = azurerm_application_insights_api_key.this
}

output "web_tests" {
  description = "web tests for application insights"
  value       = azurerm_application_insights_web_test.this
}

output "standard_web_tests" {
  description = "standard web tests for application insights"
  value       = azurerm_application_insights_standard_web_test.this
}

output "analytics_items" {
  description = "analytics items for application insights"
  value       = azurerm_application_insights_analytics_item.this
}

output "smart_detection_rules" {
  description = "smart detection rules for application insights"
  value       = azurerm_application_insights_smart_detection_rule.this
}

output "workbooks" {
  description = "workbooks for application insights"
  value       = azurerm_application_insights_workbook.this
}

output "workbook_templates" {
  description = "workbook templates for application insights"
  value       = azurerm_application_insights_workbook_template.this
}
