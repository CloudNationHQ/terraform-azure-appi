# Api Keys

This deploys several api keys.

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string

  api_keys = map(object({
    name             = string
    read_permissions = optional(list(string))
    write_permissions = optional(list(string))
  }))
})
```
