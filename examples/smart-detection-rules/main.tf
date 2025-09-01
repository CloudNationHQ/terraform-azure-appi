module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "appi" {
  source  = "cloudnationhq/appi/azure"
  version = "~> 3.0"

  config = {
    name                = module.naming.application_insights.name
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    application_type    = "web"

    smart_detection_rules = {
      slow_page_load = {
        name                               = "Slow page load time"
        send_emails_to_subscription_owners = true
        additional_email_recipients        = ["team-alerts@example.com"]
      }

      high_exception_volume = {
        name                               = "Abnormal rise in exception volume"
        send_emails_to_subscription_owners = true
      }

      potential_memory_leak = {
        name                               = "Potential memory leak detected"
        send_emails_to_subscription_owners = true
      }
    }
  }
}
