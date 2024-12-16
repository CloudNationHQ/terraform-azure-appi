module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.22"

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
  source = "../../"

  config = {
    name             = module.naming.application_insights.name
    resource_group   = module.rg.groups.demo.name
    location         = module.rg.groups.demo.location
    application_type = "web"

    workbooks = {
      requests_overview = {
        name         = "8c8cb545-5a65-4b23-b9d5-8b5b0c12cc86" # UUID for name
        display_name = "Requests Overview"
        description  = "Basic view of request counts and duration"
        category     = "workbook"
        data_json = jsonencode({
          "version" : "Notebook/1.0",
          "items" : [
            {
              "type" : 1,
              "content" : {
                "json" : "# Requests Overview\nShowing basic request metrics"
              }
            },
            {
              "type" : 3,
              "content" : {
                "version" : "KqlItem/1.0",
                "query" : "requests\n| summarize count(), avgDuration=avg(duration) by bin(timestamp, 5m)\n| order by timestamp desc",
                "size" : 0,
                "title" : "Request Count and Duration",
                "queryType" : 0,
                "resourceType" : "microsoft.insights/components",
                "visualization" : "linechart"
              }
            }
          ]
        })
      },

      error_monitor = {
        name         = "9a6ef6f9-4123-4d93-a57b-e8c5269c90bd"
        display_name = "Error Monitor"
        description  = "Simple error tracking dashboard"
        category     = "workbook"
        data_json = jsonencode({
          "version" : "Notebook/1.0",
          "items" : [
            {
              "type" : 1,
              "content" : {
                "json" : "# Error Monitor\nTracking failed requests"
              }
            },
            {
              "type" : 3,
              "content" : {
                "version" : "KqlItem/1.0",
                "query" : "requests\n| where success == false\n| summarize count() by resultCode\n| order by count_ desc",
                "size" : 0,
                "title" : "Failed Requests by Code",
                "queryType" : 0,
                "resourceType" : "microsoft.insights/components",
                "visualization" : "piechart"
              }
            }
          ]
        })
      }
    }
  }
}
