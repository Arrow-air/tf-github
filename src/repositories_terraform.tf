#####################################################################
#
# Repository settings for Terraform repositories
#
#####################################################################
locals {
  # List of service repositories to created
  # Default settings (can be overwritten here)
  # {
  #   owner_team = "services"
  #   visibility = "public"
  #   default_branch = "main"
  #   default_branch_protection_settings = {
  #     required_pull_request_reviews = { 
  #       required_approving_review_count = 2
  #     }
  #   }
  # }
  tf_repos = {
    "onboarding" = {
      description = "users and groups for resources manageable by Terraform"
      visibility  = "private"
      owner_team  = "devops"
    }
    "github" = {
      description = "github resources"
    }
  }
}


module "tf_repository" {
  source   = "./modules/github-repository/"
  for_each = local.tf_repos

  name        = format("tf-%s", each.key)
  description = format("Terraform - %s", each.value.description)

  # Settings with defaults
  owner_team     = try(each.value.owner_team, "services")
  visibility     = try(each.value.visibility, "public")
  default_branch = try(each.value.default_branch, "main")
  webhooks       = local.svc.webhooks

  collaborators = {
    maintainers = ["devops"]
  }

  # override review_count for branch protection settings
  default_branch_protection_settings = {
    required_pull_request_reviews = {
      required_approving_review_count = 2
    }
  }
}
