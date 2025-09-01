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

    api_keys = {
      read_only_key = {
        name             = "ReadOnlyKey"
        read_permissions = ["api"]
      }

      write_annotations_key = {
        name              = "WriteAnnotationsKey"
        write_permissions = ["annotations"]
      }
    }
  }
}
