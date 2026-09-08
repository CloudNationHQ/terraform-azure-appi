# insights
resource "azurerm_application_insights" "this" {
  resource_group_name = coalesce(
    var.insights.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.insights.location, var.location
  )

  name                                 = var.insights.name
  application_type                     = var.insights.application_type
  daily_data_cap_in_gb                 = var.insights.daily_data_cap_in_gb
  daily_data_cap_notifications_enabled = var.insights.daily_data_cap_notifications_enabled
  retention_in_days                    = var.insights.retention_in_days
  sampling_percentage                  = var.insights.sampling_percentage
  ip_masking_enabled                   = var.insights.ip_masking_enabled
  workspace_id                         = var.insights.workspace_id
  local_authentication_enabled         = var.insights.local_authentication_enabled
  internet_ingestion_enabled           = var.insights.internet_ingestion_enabled
  internet_query_enabled               = var.insights.internet_query_enabled
  force_customer_storage_for_profiler  = var.insights.force_customer_storage_for_profiler

  tags = coalesce(
    var.insights.tags, var.tags
  )
}

resource "azurerm_application_insights_analytics_item" "this" {
  for_each = var.insights.analytics_items

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.this.id
  type                    = each.value.type
  scope                   = each.value.scope
  content                 = each.value.content
  function_alias          = each.value.function_alias
}

resource "azurerm_application_insights_api_key" "this" {
  for_each = var.insights.api_keys

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.this.id
  read_permissions        = each.value.read_permissions
  write_permissions       = each.value.write_permissions
}

resource "azurerm_application_insights_smart_detection_rule" "this" {
  for_each = var.insights.smart_detection_rules

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id            = azurerm_application_insights.this.id
  enabled                            = each.value.enabled
  send_emails_to_subscription_owners = each.value.send_emails_to_subscription_owners
  additional_email_recipients        = each.value.additional_email_recipients
}

resource "azurerm_application_insights_standard_web_test" "this" {
  for_each = var.insights.standard_web_tests

  resource_group_name = coalesce(
    var.insights.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.insights.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.this.id
  geo_locations           = each.value.geo_locations
  description             = each.value.description
  enabled                 = each.value.enabled
  frequency               = each.value.frequency
  retry_enabled           = each.value.retry_enabled
  timeout                 = each.value.timeout

  tags = coalesce(
    var.insights.tags, var.tags
  )

  dynamic "request" {
    for_each = each.value.request != null ? { "this" = each.value.request } : {}

    content {
      url                              = request.value.url
      body                             = request.value.body
      follow_redirects_enabled         = request.value.follow_redirects_enabled
      http_verb                        = request.value.http_verb
      parse_dependent_requests_enabled = request.value.parse_dependent_requests_enabled

      dynamic "header" {
        for_each = request.value.header != null ? { "this" = request.value.header } : {}

        content {
          name  = header.value.name
          value = header.value.value
        }
      }
    }
  }

  dynamic "validation_rules" {
    for_each = each.value.validation_rules != null ? { "this" = each.value.validation_rules } : {}

    content {
      expected_status_code        = validation_rules.value.expected_status_code
      ssl_cert_remaining_lifetime = validation_rules.value.ssl_cert_remaining_lifetime
      ssl_check_enabled           = validation_rules.value.ssl_check_enabled

      dynamic "content" {
        for_each = validation_rules.value.content != null ? { "this" = validation_rules.value.content } : {}

        content {
          content_match      = content.value.content_match
          ignore_case        = content.value.ignore_case
          pass_if_text_found = content.value.pass_if_text_found
        }
      }
    }
  }
}

resource "azurerm_application_insights_web_test" "this" {
  for_each = var.insights.web_tests

  resource_group_name = coalesce(
    var.insights.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.insights.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  application_insights_id = azurerm_application_insights.this.id
  kind                    = each.value.kind
  geo_locations           = each.value.geo_locations
  configuration           = each.value.configuration
  frequency               = each.value.frequency
  timeout                 = each.value.timeout
  enabled                 = each.value.enabled
  retry_enabled           = each.value.retry_enabled
  description             = each.value.description

  tags = coalesce(
    var.insights.tags, var.tags
  )
}

resource "azurerm_application_insights_workbook" "this" {
  for_each = var.insights.workbooks

  resource_group_name = coalesce(
    var.insights.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.insights.location, var.location
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
  source_id            = coalesce(each.value.source_id, lower(azurerm_application_insights.this.id))

  dynamic "identity" {
    for_each = each.value.identity != null ? { "this" = each.value.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = coalesce(
    var.insights.tags, var.tags
  )
}

resource "azurerm_application_insights_workbook_template" "this" {
  for_each = var.insights.workbook_templates

  resource_group_name = coalesce(
    var.insights.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.insights.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  template_data = each.value.source
  priority      = each.value.priority
  localized     = each.value.localized
  author        = each.value.author

  tags = coalesce(
    var.insights.tags, var.tags
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
