# insights
resource "azurerm_application_insights" "appi" {
  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name                                  = var.config.name
  application_type                      = var.config.application_type
  daily_data_cap_in_gb                  = var.config.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.config.daily_data_cap_notifications_disabled
  retention_in_days                     = var.config.retention_in_days
  sampling_percentage                   = var.config.sampling_percentage
  disable_ip_masking                    = var.config.disable_ip_masking
  workspace_id                          = var.config.workspace_id
  local_authentication_disabled         = var.config.local_authentication_disabled
  internet_ingestion_enabled            = var.config.internet_ingestion_enabled
  internet_query_enabled                = var.config.internet_query_enabled
  force_customer_storage_for_profiler   = var.config.force_customer_storage_for_profiler

  tags = coalesce(
    var.config.tags, var.tags
  )
}

# analytics items
resource "azurerm_application_insights_analytics_item" "analytics_item" {
  for_each = var.config.analytics_items

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.appi.id
  type                    = each.value.type
  scope                   = each.value.scope
  content                 = each.value.content
  function_alias          = each.value.function_alias
}

# api keys
resource "azurerm_application_insights_api_key" "api_key" {
  for_each = var.config.api_keys

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.appi.id
  read_permissions        = each.value.read_permissions
  write_permissions       = each.value.write_permissions
}

# smart detection rules
resource "azurerm_application_insights_smart_detection_rule" "sdr" {
  for_each = var.config.smart_detection_rules

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id            = azurerm_application_insights.appi.id
  enabled                            = each.value.enabled
  send_emails_to_subscription_owners = each.value.send_emails_to_subscription_owners
  additional_email_recipients        = each.value.additional_email_recipients
}

# standard web tests
resource "azurerm_application_insights_standard_web_test" "swt" {
  for_each = var.config.standard_web_tests

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.appi.id
  geo_locations           = each.value.geo_locations
  description             = each.value.description
  enabled                 = each.value.enabled
  frequency               = each.value.frequency
  retry_enabled           = each.value.retry_enabled
  timeout                 = each.value.timeout

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "request" {
    for_each = each.value.request != null ? [each.value.request] : []
    content {
      url                              = request.value.url
      body                             = request.value.body
      follow_redirects_enabled         = request.value.follow_redirects_enabled
      http_verb                        = request.value.http_verb
      parse_dependent_requests_enabled = request.value.parse_dependent_requests_enabled

      dynamic "header" {
        for_each = request.value.header != null ? [request.value.header] : []
        content {
          name  = header.value.name
          value = header.value.value
        }
      }
    }
  }

  dynamic "validation_rules" {
    for_each = each.value.validation_rules != null ? [each.value.validation_rules] : []

    content {
      expected_status_code        = validation_rules.value.expected_status_code
      ssl_cert_remaining_lifetime = validation_rules.value.ssl_cert_remaining_lifetime
      ssl_check_enabled           = validation_rules.value.ssl_check_enabled

      dynamic "content" {
        for_each = validation_rules.value.content != null ? [validation_rules.value.content] : []

        content {
          content_match      = content.value.content_match
          ignore_case        = content.value.ignore_case
          pass_if_text_found = content.value.pass_if_text_found
        }
      }
    }
  }
}

# web tests
resource "azurerm_application_insights_web_test" "wt" {
  for_each = var.config.web_tests

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.appi.id
  kind                    = each.value.kind
  geo_locations           = each.value.geo_locations
  configuration           = each.value.configuration
  frequency               = each.value.frequency
  timeout                 = each.value.timeout
  enabled                 = each.value.enabled
  retry_enabled           = each.value.retry_enabled
  description             = each.value.description

  tags = coalesce(
    var.config.tags, var.tags
  )
}

# workbooks
resource "azurerm_application_insights_workbook" "wb" {
  for_each = var.config.workbooks

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  display_name = coalesce(
    each.value.display_name, each.key
  )

  description          = each.value.description
  storage_container_id = each.value.storage_container_id
  category             = each.value.category
  data_json            = each.value.data_json
  source_id            = coalesce(each.value.source_id, lower(azurerm_application_insights.appi.id))

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = "UserAssigned"
      identity_ids = identity.value.identity_ids
    }
  }

  tags = coalesce(
    var.config.tags, var.tags
  )
}

# workbook templates
resource "azurerm_application_insights_workbook_template" "tmpl" {
  for_each = var.config.workbook_templates

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  template_data = each.value.source
  priority      = each.value.priority
  localized     = each.value.localized
  author        = each.value.author

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "galleries" {
    for_each = each.value.galleries

    content {
      category      = galleries.value.category
      name          = galleries.value.name
      order         = galleries.value.order
      resource_type = galleries.value.resource_type
      type          = galleries.value.type
    }
  }
}
