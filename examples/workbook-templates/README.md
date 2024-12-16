# Workbook Templates

This deploys workbook templates.

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string

  workbook_templates = map(object({
    name     = string
    priority = optional(number)
    localized = optional(map(string))
    author   = optional(string)

    galleries = map(object({
      category      = string
      name          = string
      order         = optional(number)
      resource_type = string
      type          = string
    }))

    template_data = string
  }))
})
```
