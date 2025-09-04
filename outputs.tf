output "config" {
  description = "configuration for applications insights"
  value       = azurerm_application_insights.appi
}

output "api_keys" {
  description = "api keys for applications insights"
  value       = azurerm_application_insights_api_key.api_key
}

output "web_tests" {
  description = "web tests for application insights"
  value       = azurerm_application_insights_web_test.wt
}

output "standard_web_tests" {
  description = "standard web tests for application insights"
  value       = azurerm_application_insights_standard_web_test.swt
}

output "analytics_items" {
  description = "analytics items for application insights"
  value       = azurerm_application_insights_analytics_item.analytics_item
}

output "smart_detection_rules" {
  description = "smart detection rules for application insights"
  value       = azurerm_application_insights_smart_detection_rule.sdr
}

output "workbooks" {
  description = "workbooks for application insights"
  value       = azurerm_application_insights_workbook.wb
}

output "workbook_templates" {
  description = "workbook templates for application insights"
  value       = azurerm_application_insights_workbook_template.tmpl
}

