# Analytics Items

This deploys several analytics items.

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string
  workspace_id     = optional(string)

  analytics_items = map(object({
    name    = string
    content = string
    scope   = optional(string)
    type    = optional(string)
  }))
})
```
