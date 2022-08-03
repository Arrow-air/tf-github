#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  svc = {
    repository_prefix  = "svc"
    description_prefix = "Arrow Services"

    # List of webhooks to apply for all services repositories
    webhooks = {
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

    # List of service repositories to be created
    # Default settings without override
    # {
    #   name           = "<repository_prefix>-<svc_template_repos key>"
    #   description    = "<description_prefix> - <description>"
    # }
    # Default settings (can be overwritten here)
    # {
    #   owner_team     = "services"
    #   visibility     = "public"
    #   default_branch = "dev"
    #   template       = github_repository.svc_template_rust.name
    #   webhooks       = local.svc.webhooks
    #   default_branch_protection_settings = {} # Using module defaults
    # }
    repos = {
      "storage" = {
        description = "Storage module"
      }
    }
  }
}

########################################################
# Services repositories
########################################################
module "svc_repository" {
  source   = "./modules/github-repository/"
  for_each = local.svc.repos

  name        = format("%s-%s", local.svc.repository_prefix, each.key)
  description = format("%s - %s", local.svc.description_prefix, each.value.description)

  # Settings with defaults
  owner_team     = try(each.value.owner_team, "services")
  visibility     = try(each.value.visibility, "public")
  default_branch = try(each.value.default_branch, "develop")
  template       = github_repository.svc_template_rust.name
  webhooks       = local.svc.webhooks

  default_branch_protection_settings = try(each.value.default_branch_protection_settings, {})
}
