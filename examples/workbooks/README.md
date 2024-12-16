# Workbooks

This deploys workbooks

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string

  workbooks = map(object({
    name         = string
    display_name = string
    description  = optional(string)
    category     = string
    data_json    = string
  }))
})
```
