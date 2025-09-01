variable "config" {
  description = "describes the application insights configuration"
  type = object({
    name                                  = optional(string)
    location                              = optional(string)
    resource_group_name                   = optional(string)
    application_type                      = string
    daily_data_cap_in_gb                  = optional(number, 100)
    daily_data_cap_notifications_disabled = optional(bool, false)
    retention_in_days                     = optional(number, 90)
    sampling_percentage                   = optional(number, 100)
    disable_ip_masking                    = optional(bool, false)
    workspace_id                          = optional(string)
    local_authentication_disabled         = optional(bool, false)
    internet_ingestion_enabled            = optional(bool, true)
    internet_query_enabled                = optional(bool, true)
    force_customer_storage_for_profiler   = optional(bool, false)
    tags                                  = optional(map(string))
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
      enabled                            = optional(bool, true)
      send_emails_to_subscription_owners = optional(bool, true)
      additional_email_recipients        = optional(set(string), [])
    })), {})
    standard_web_tests = optional(map(object({
      name          = optional(string)
      geo_locations = set(string)
      description   = optional(string)
      enabled       = optional(bool)
      frequency     = optional(number, 300)
      retry_enabled = optional(bool)
      timeout       = optional(number, 30)
      request = optional(object({
        url                              = string
        body                             = optional(string)
        follow_redirects_enabled         = optional(bool, true)
        http_verb                        = optional(string, "GET")
        parse_dependent_requests_enabled = optional(bool, true)
        header = optional(object({
          name  = string
          value = string
        }))
      }))
      validation_rules = optional(object({
        expected_status_code        = optional(number, 200)
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
      frequency     = optional(number, 300)
      timeout       = optional(number, 30)
      enabled       = optional(bool)
      retry_enabled = optional(bool)
      description   = optional(string)
    })), {})
    workbooks = optional(map(object({
      name                 = optional(string)
      display_name         = optional(string)
      description          = optional(string)
      storage_container_id = optional(string)
      category             = optional(string, "workbook")
      data_json            = string
      source_id            = optional(string)
      identity = optional(object({
        identity_ids = set(string)
      }))
    })), {})
    workbook_templates = optional(map(object({
      name      = optional(string)
      source    = string
      priority  = optional(number)
      localized = optional(string)
      author    = optional(string)
      galleries = optional(map(object({
        category      = optional(string, "workbook")
        name          = string
        order         = optional(number, 100)
        resource_type = string
        type          = string
      })), {})
    })), {})
  })

  validation {
    condition     = var.config.daily_data_cap_in_gb >= 0.023 && var.config.daily_data_cap_in_gb <= 1000
    error_message = "Daily data cap must be between 0.023 and 1000 GB."
  }

  validation {
    condition     = var.config.sampling_percentage >= 0 && var.config.sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }

  validation {
    condition = alltrue([
      for key, api_key in var.config.api_keys : (
        api_key.read_permissions != null || api_key.write_permissions != null
      )
    ])
    error_message = "Each API key must have at least one read or write permission."
  }

  validation {
    condition = alltrue([
      for key, swt in var.config.standard_web_tests : (
        contains([300, 600, 900], swt.frequency)
      )
    ])
    error_message = "Standard web test frequency must be one of: 300, 600, 900 seconds."
  }

  validation {
    condition = alltrue([
      for key, swt in var.config.standard_web_tests : (
        swt.timeout < swt.frequency
      )
    ])
    error_message = "Standard web test timeout must be less than frequency."
  }

  validation {
    condition = alltrue([
      for key, wt in var.config.web_tests : (
        contains([300, 600, 900], wt.frequency)
      )
    ])
    error_message = "Web test frequency must be one of: 300, 600, 900 seconds."
  }

  validation {
    condition = alltrue([
      for key, wt in var.config.web_tests : (
        wt.timeout < wt.frequency
      )
    ])
    error_message = "Web test timeout must be less than frequency."
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
