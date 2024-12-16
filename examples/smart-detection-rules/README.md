# Smart Detection Rules

This deploys smart detection rules.

## Types

```hcl
config = object({
  name             = string
  resource_group   = string
  location         = string
  application_type = string

  smart_detection_rules = map(object({
    name                               = string
    send_emails_to_subscription_owners = optional(bool)
    additional_email_recipients        = optional(list(string))
  }))
})
```
