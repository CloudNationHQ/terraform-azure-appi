# insights
resource "azurerm_application_insights" "appi" {
  name                                  = try(var.config.name, var.naming.application_insights)
  location                              = coalesce(lookup(var.config, "location", null), var.location)
  resource_group_name                   = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  application_type                      = var.config.application_type
  daily_data_cap_in_gb                  = try(var.config.daily_data_cap_in_gb, 100)
  daily_data_cap_notifications_disabled = try(var.config.daily_data_cap_notifications_disabled, false)
  retention_in_days                     = try(var.config.retention_in_days, 90)
  sampling_percentage                   = try(var.config.sampling_percentage, 100)
  disable_ip_masking                    = try(var.config.disable_ip_masking, false)
  workspace_id                          = try(var.config.workspace_id, null)
  local_authentication_disabled         = try(var.config.local_authentication_disabled, false)
  internet_ingestion_enabled            = try(var.config.internet_ingestion_enabled, true)
  internet_query_enabled                = try(var.config.internet_query_enabled, true)
  force_customer_storage_for_profiler   = try(var.config.force_customer_storage_for_profiler, false)

  tags = try(
    var.config.tags, var.tags, {}
  )
}

# analytics items
resource "azurerm_application_insights_analytics_item" "analytics_item" {
  for_each = {
    for key, analytics_item in lookup(var.config, "analytics_items", {}) : key => analytics_item
  }

  name                    = try(each.value.name, each.key)
  application_insights_id = azurerm_application_insights.appi.id
  type                    = each.value.type
  scope                   = each.value.scope
  content                 = each.value.content
  function_alias          = try(each.value.function_alias, null)
}

# api keys
resource "azurerm_application_insights_api_key" "api_key" {
  for_each = {
    for key, api_key in lookup(var.config, "api_keys", {}) : key => api_key
  }

  name                    = try(each.value.name, each.key)
  application_insights_id = azurerm_application_insights.appi.id
  read_permissions        = try(each.value.read_permissions, null)
  write_permissions       = try(each.value.write_permissions, null)
}

# smart detection rules
resource "azurerm_application_insights_smart_detection_rule" "sdr" {
  for_each = {
    for key, sdr in lookup(var.config, "smart_detection_rules", {}) : key => sdr
  }

  name                               = try(each.value.name, each.key)
  application_insights_id            = azurerm_application_insights.appi.id
  enabled                            = try(each.value.enabled, true)
  send_emails_to_subscription_owners = try(each.value.send_emails_to_subscription_owners, true)
  additional_email_recipients        = try(each.value.additional_email_recipients, [])
}

# standard web tests
resource "azurerm_application_insights_standard_web_test" "swt" {
  for_each = {
    for key, swt in lookup(var.config, "standard_web_tests", {}) : key => swt
  }

  name                    = try(each.value.name, each.key)
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location                = coalesce(lookup(var.config, "location", null), var.location)
  application_insights_id = azurerm_application_insights.appi.id
  geo_locations           = each.value.geo_locations
  description             = try(each.value.description, null)
  enabled                 = try(each.value.enabled, null)
  frequency               = try(each.value.frequency, 300)
  retry_enabled           = try(each.value.retry_enabled, null)
  tags                    = try(var.config.tags, var.tags, {})
  timeout                 = try(each.value.timeout, 30)

  dynamic "request" {
    for_each = lookup(each.value, "request", null) != null ? [each.value.request] : []
    content {
      url                              = request.value.url
      body                             = try(request.value.body, null)
      follow_redirects_enabled         = try(request.value.follow_redirects_enabled, true)
      http_verb                        = try(request.value.http_verb, "GET")
      parse_dependent_requests_enabled = try(request.value.parse_dependent_requests_enabled, true)

      dynamic "header" {
        for_each = lookup(request.value, "header", null) != null ? [request.value.header] : []
        content {
          name  = header.value.name
          value = header.value.value
        }
      }
    }
  }

  dynamic "validation_rules" {
    for_each = lookup(each.value, "validation_rules", null) != null ? [each.value.validation_rules] : []
    content {
      expected_status_code        = try(validation_rules.value.expected_status_code, 200)
      ssl_cert_remaining_lifetime = try(validation_rules.value.ssl_cert_remaining_lifetime, null)
      ssl_check_enabled           = try(validation_rules.value.ssl_check_enabled, null)

      dynamic "content" {
        for_each = lookup(validation_rules.value, "content", null) != null ? [validation_rules.value.content] : []
        content {
          content_match      = content.value.content_match
          ignore_case        = try(content.value.ignore_case, null)
          pass_if_text_found = try(content.value.pass_if_text_found, null)
        }
      }
    }
  }
}

# web tests
resource "azurerm_application_insights_web_test" "wt" {
  for_each = {
    for key, wt in lookup(var.config, "web_tests", {}) : key => wt
  }

  name                    = try(each.value.name, each.key)
  location                = coalesce(lookup(var.config, "location", null), var.location)
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  application_insights_id = azurerm_application_insights.appi.id
  kind                    = each.value.kind
  geo_locations           = each.value.geo_locations
  configuration           = each.value.configuration
  frequency               = try(each.value.frequency, 300)
  timeout                 = try(each.value.timeout, 30)
  enabled                 = try(each.value.enabled, null)
  retry_enabled           = try(each.value.retry_enabled, null)
  description             = try(each.value.description, null)
  tags                    = try(var.config.tags, var.tags, {})
}

# workbooks
resource "azurerm_application_insights_workbook" "wb" {
  for_each = {
    for key, workbook in lookup(var.config, "workbooks", {}) : key => workbook
  }

  name                = try(each.value.name, each.key)
  resource_group_name = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.config, "location", null), var.location)
  display_name        = try(each.value.display_name, each.key)
  description         = try(each.value.description, null)
  category            = try(each.value.category, "workbook")
  data_json           = each.value.data_json
  source_id           = try(lower(lookup(each.value, "source_id", azurerm_application_insights.appi.id)), null)

  tags = try(
    var.config.tags, var.tags, {}
  )
}

# workbook templates
resource "azurerm_application_insights_workbook_template" "tmpl" {
  for_each = {
    for key, template in lookup(var.config, "workbook_templates", {}) : key => template
  }

  name                = try(each.value.name, each.key)
  resource_group_name = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.config, "location", null), var.location)
  template_data       = each.value.source
  priority            = try(each.value.priority, null)
  localized           = try(each.value.localized, null)
  author              = try(each.value.author, null)

  tags = try(
    var.config.tags, var.tags, {}
  )

  dynamic "galleries" {
    for_each = try(
      each.value.galleries, {}
    )

    content {
      category      = try(galleries.value.category, "workbook")
      name          = galleries.value.name
      order         = try(galleries.value.order, 100)
      resource_type = galleries.value.resource_type
      type          = galleries.value.type
    }
  }
}
