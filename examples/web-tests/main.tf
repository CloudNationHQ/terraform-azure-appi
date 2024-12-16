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
  source  = "cloudnationhq/appi/azure"
  version = "~> 2.0"

  config = {
    name             = module.naming.application_insights.name
    resource_group   = module.rg.groups.demo.name
    location         = module.rg.groups.demo.location
    application_type = "web"

    standard_web_tests = {
      homepage_check = {
        name          = "HomepageCheck"
        geo_locations = ["emea-nl-ams-azr"]
        description   = "Standard Web Test for Homepage Availability"
        enabled       = true
        frequency     = 300
        retry_enabled = true
        request = {
          url = "https://www.myecommerce.com"
        }
      }

      api_health_check = {
        name          = "APIHealthCheck"
        geo_locations = ["emea-nl-ams-azr"]
        description   = "Standard Web Test for API Health"
        enabled       = true
        frequency     = 600
        retry_enabled = false
        request = {
          url                              = "https://api.myecommerce.com/health"
          http_verb                        = "GET"
          follow_redirects_enabled         = true
          parse_dependent_requests_enabled = false
        }
      }
    }

    web_tests = {
      search_functionality_test = {
        name          = "SearchFunctionalityTest"
        geo_locations = ["emea-nl-ams-azr"]
        description   = "Simulated Search Test"
        kind          = "multistep"
        configuration = <<XML
<WebTest Name="SearchTest" Id="E3B7F45B-1A2D-4F87-82FA-3B85F34989AB" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="Simulate a search feature" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="1A1B29A9-7D92-4E89-AF9C-888FABD38F8A" Version="1.1" Url="https://www.myecommerce.com/search?q=shoes" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
      }

      checkout_page_test = {
        name          = "CheckoutPageTest"
        geo_locations = ["emea-nl-ams-azr"]
        description   = "Ping Test for Checkout Page"
        kind          = "ping"
        configuration = <<XML
<WebTest Name="CheckoutPingTest" Id="BF5E4285-2EDC-4F12-9B7B-4FEEDA2546D9" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="Ping the checkout page" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="BD82F47A-6357-4E77-AB5F-D987EEDB258F" Version="1.1" Url="https://www.myecommerce.com/checkout" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
      }
    }
  }
}
