variable "insights" {
  description = "describes the application insights configuration"
  type = object({
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

  validation {
    condition     = lookup(var.insights, "location", null) != null || var.location != null
    error_message = "location must be set on var.insights.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.insights, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.insights.resource_group_name or on the module-level var.resource_group_name."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
