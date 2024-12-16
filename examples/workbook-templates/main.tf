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

    workbook_templates = {
      basic_metrics = {
        name     = "app-metrics-template"
        priority = 1
        author   = "Platform Team"

        galleries = {
          operations = {
            category      = "Operations"
            name          = "Application Metrics"
            order         = 100
            resource_type = "microsoft.insights/components"
            type          = "workbook"
          }
        }

        source = jsonencode({
          "version" : "Notebook/1.0",
          "items" : [
            {
              "type" : 1,
              "content" : {
                "json" : "# Application Monitoring Dashboard\nShowing key metrics for your application"
              }
            },
            {
              "type" : 3,
              "content" : {
                "version" : "KqlItem/1.0",
                "query" : "requests\n| summarize ['Total Requests'] = count(), ['Failed Requests'] = countif(success == false), ['Avg Duration (ms)'] = avg(duration) by bin(timestamp, 5m)\n| order by timestamp desc",
                "size" : 1,
                "title" : "Request Summary (5-minute intervals)",
                "timeContext" : {
                  "durationMs" : 3600000
                },
                "queryType" : 0,
                "resourceType" : "microsoft.insights/components",
                "visualization" : "table",
                "gridSettings" : {
                  "formatters" : [
                    {
                      "columnMatch" : "Failed Requests",
                      "formatter" : 8,
                      "formatOptions" : {
                        "palette" : "red"
                      }
                    },
                    {
                      "columnMatch" : "Avg Duration",
                      "formatter" : 8,
                      "formatOptions" : {
                        "palette" : "blue"
                      }
                    }
                  ]
                }
              }
            },
            {
              "type" : 3,
              "content" : {
                "version" : "KqlItem/1.0",
                "query" : "requests\n| summarize ['Success Rate (%)'] = 100.0 * countif(success == true) / count() by bin(timestamp, 5m)\n| order by timestamp desc",
                "size" : 1,
                "title" : "Success Rate Over Time",
                "timeContext" : {
                  "durationMs" : 3600000
                },
                "queryType" : 0,
                "resourceType" : "microsoft.insights/components",
                "visualization" : "linechart"
              }
            }
          ]
        })
      }
    }
  }
}
