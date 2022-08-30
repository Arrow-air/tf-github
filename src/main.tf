locals {
  # Secret provided by Terraform Cloud configuration on the workspace
  discord_services_integration_url = sensitive(var.discord_services_integration_url)

  # List of webhooks to apply for repositories owned by team
  webhooks = {
    services = {
      "discord" = {
        events = [
          "pull_request",
          "pull_request_review",
          "pull_request_review_comment",
          "pull_request_review_thread"
        ]
        configuration = {
          url = local.discord_services_integration_url
        }
      }
    }
  }

  repos = {
    "website" = {
      default_branch = "staging"
      description    = "Arrowair website and documentation with Docusaurus"
      visibility     = "public"
      owner_team     = "webdevelopers"
    }
    "cla-bot" = {
      description = "Arrow CLA bot API code and deployment files"
      visibility  = "public"
      owner_team  = "devops"
    }
    "clabot-config" = {
      description = "Arrow CLA bot global configuration"
      visibility  = "private"
      owner_team  = "devops"
      # override review_count for branch protection settings
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          required_approving_review_count = 2
        }
      }
    }
    "tools" = {
      description = "Software used for Arrow engineering"
      visibility  = "public"
      owner_team  = "drone-engineering"
    }
    "benchmarks" = {
      description      = "In-house benchmarks for various frameworks."
      visibility       = "public"
      owner_team       = "services"
      repository_files = local.rust_default.files
    }
    "se-services" = {
      default_branch = "develop"
      description    = "Systems Engineering documentation for Aerial Mobility Services"
      visibility     = "public"
      owner_team     = "services"
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          required_approving_review_count = 2
        }
      }
    }
  }
}

module "repository" {
  source   = "./modules/github-repository/"
  for_each = local.repos

  name             = each.key
  description      = each.value.description
  visibility       = each.value.visibility
  default_branch   = try(each.value.default_branch, "main")
  repository_files = try(each.value.repository_files, {})

  default_branch_protection_settings = try(each.value.default_branch_protection_settings, {})

  owner_team = each.value.owner_team
  template   = try(each.value.template, null)
}
