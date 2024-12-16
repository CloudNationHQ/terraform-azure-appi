# Application Insights

This Terraform module simplifies the setup and management of Azure Application Insights, offering customizable configurations for creating and maintaining application insights instances. Application Insights collects telemetry about your app, including web server telemetry, web page telemetry, and performance counters. This data can be used to monitor your app's performance, health, and usage.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

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

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-appi/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/application-insights/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/applicationinsights)
