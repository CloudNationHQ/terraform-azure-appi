# Application Insights

This Terraform module streamlines the creation and management of azure application insights. It collects telemetry such as server metrics, web page data, and performance counters, enabling you to monitor application performance, health, and usage effectively.

## Features

Tracks telemetry such as requests, dependencies, and exceptions.

Supports sampling rates, data caps, and retention policies.

Integrates with Log Analytics for centralized log analysis.

Manages secure access with api keys and configurable permissions.

Provides alerts using smart detection rules.

Supports custom analytics queries with shared or private scopes.

Monitors availability with standard and web Tests.

Enables dashboards with workbooks and reusable templates.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) (resource)
- [azurerm_application_insights_analytics_item.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_analytics_item) (resource)
- [azurerm_application_insights_api_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_api_key) (resource)
- [azurerm_application_insights_smart_detection_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_smart_detection_rule) (resource)
- [azurerm_application_insights_standard_web_test.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test) (resource)
- [azurerm_application_insights_web_test.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) (resource)
- [azurerm_application_insights_workbook.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) (resource)
- [azurerm_application_insights_workbook_template.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook_template) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_insights"></a> [insights](#input\_insights)

Description: describes the application insights configuration

Type:

```hcl
object({
    name                                 = optional(string)
    location                             = optional(string)
    resource_group_name                  = optional(string)
    application_type                     = string
    daily_data_cap_in_gb                 = optional(number)
    daily_data_cap_notifications_enabled = optional(bool)
    retention_in_days                    = optional(number)
    sampling_percentage                  = optional(number)
    ip_masking_enabled                   = optional(bool)
    workspace_id                         = optional(string)
    local_authentication_enabled         = optional(bool)
    internet_ingestion_enabled           = optional(bool)
    internet_query_enabled               = optional(bool)
    force_customer_storage_for_profiler  = optional(bool)
    tags                                 = optional(map(string))
    analytics_items = optional(map(object({
      name           = optional(string)
      type           = string
      scope          = string
      content        = string
      function_alias = optional(string)
    })), {})
    api_keys = optional(map(object({
      name              = optional(string)
      read_permissions  = optional(set(string))
      write_permissions = optional(set(string))
    })), {})
    smart_detection_rules = optional(map(object({
      name                               = optional(string)
      enabled                            = optional(bool)
      send_emails_to_subscription_owners = optional(bool)
      additional_email_recipients        = optional(set(string))
    })), {})
    standard_web_tests = optional(map(object({
      name          = optional(string)
      geo_locations = set(string)
      description   = optional(string)
      enabled       = optional(bool)
      frequency     = optional(number)
      retry_enabled = optional(bool)
      timeout       = optional(number)
      request = optional(object({
        url                              = string
        body                             = optional(string)
        follow_redirects_enabled         = optional(bool)
        http_verb                        = optional(string)
        parse_dependent_requests_enabled = optional(bool)
        header = optional(object({
          name  = string
          value = string
        }))
      }))
      validation_rules = optional(object({
        expected_status_code        = optional(number)
        ssl_cert_remaining_lifetime = optional(number)
        ssl_check_enabled           = optional(bool)
        content = optional(object({
          content_match      = string
          ignore_case        = optional(bool)
          pass_if_text_found = optional(bool)
        }))
      }))
    })), {})
    web_tests = optional(map(object({
      name          = optional(string)
      kind          = string
      geo_locations = set(string)
      configuration = string
      frequency     = optional(number)
      timeout       = optional(number)
      enabled       = optional(bool)
      retry_enabled = optional(bool)
      description   = optional(string)
    })), {})
    workbooks = optional(map(object({
      name                 = optional(string)
      display_name         = optional(string)
      description          = optional(string)
      storage_container_id = optional(string)
      category             = optional(string)
      data_json            = string
      source_id            = optional(string)
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string))
      }))
    })), {})
    workbook_templates = optional(map(object({
      name      = optional(string)
      source    = string
      priority  = optional(number)
      localized = optional(string)
      author    = optional(string)
      galleries = optional(map(object({
        category      = string
        name          = string
        order         = optional(number)
        resource_type = string
        type          = string
      })), {})
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_analytics_items"></a> [analytics\_items](#output\_analytics\_items)

Description: analytics items for application insights

### <a name="output_api_keys"></a> [api\_keys](#output\_api\_keys)

Description: api keys for applications insights

### <a name="output_insights"></a> [insights](#output\_insights)

Description: configuration for applications insights

### <a name="output_smart_detection_rules"></a> [smart\_detection\_rules](#output\_smart\_detection\_rules)

Description: smart detection rules for application insights

### <a name="output_standard_web_tests"></a> [standard\_web\_tests](#output\_standard\_web\_tests)

Description: standard web tests for application insights

### <a name="output_web_tests"></a> [web\_tests](#output\_web\_tests)

Description: web tests for application insights

### <a name="output_workbook_templates"></a> [workbook\_templates](#output\_workbook\_templates)

Description: workbook templates for application insights

### <a name="output_workbooks"></a> [workbooks](#output\_workbooks)

Description: workbooks for application insights
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

The `custom_action` block in auto_heal_setting is only supported for Windows web apps. Linux web apps do not support custom actions due to azure platform limitations.

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/application-insights/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/applicationinsights)
