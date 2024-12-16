# Web Tests

This deploys web tests.

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string

  standard_web_tests = map(object({
    name          = string
    geo_locations = list(string)
    description   = optional(string)
    enabled       = optional(bool)
    frequency     = optional(number)
    retry_enabled = optional(bool)
    request = object({
      url                              = string
      http_verb                        = optional(string)
      follow_redirects_enabled         = optional(bool)
      parse_dependent_requests_enabled = optional(bool)
    })
  }))

  web_tests = map(object({
    name          = string
    geo_locations = list(string)
    description   = optional(string)
    kind          = string
    configuration = string
  }))
})
```
