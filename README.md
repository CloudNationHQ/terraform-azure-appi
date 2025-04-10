# Application Insights

This Terraform module streamlines the creation and management of azure application insights. It collects telemetry such as server metrics, web page data, and performance counters, enabling you to monitor application performance, health, and usage effectively.

## Features

- tracks telemetry such as requests, dependencies, and exceptions.
- supports sampling rates, data caps, and retention policies.
- integrates with Log Analytics for centralized log analysis.
- manages secure access with api keys and configurable permissions.
- provides alerts using smart detection rules.
- supports custom analytics queries with shared or private scopes.
- monitors availability with standard and web Tests.
- enables dashboards with workbooks and reusable templates.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.appi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights_analytics_item.analytics_item](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_analytics_item) | resource |
| [azurerm_application_insights_api_key.api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_api_key) | resource |
| [azurerm_application_insights_smart_detection_rule.sdr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_smart_detection_rule) | resource |
| [azurerm_application_insights_standard_web_test.swt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test) | resource |
| [azurerm_application_insights_web_test.wt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) | resource |
| [azurerm_application_insights_workbook.wb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook) | resource |
| [azurerm_application_insights_workbook_template.tmpl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_workbook_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | describes the application insights configuration | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | default azure region to be used. | `string` | `null` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | contains naming convention | `map(string)` | `{}` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | default resource group to be used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_keys"></a> [api\_keys](#output\_api\_keys) | api keys for applications insights |
| <a name="output_config"></a> [config](#output\_config) | configuration for applications insights |
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-appi/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-appi" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/application-insights/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/applicationinsights)
