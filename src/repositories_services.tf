#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  # List of service repositories to created
  # Default settings (can be overwritten here)
  # {
  #   owner_team = "services"
  #   visibility = "public"
  #   default_branch = "dev"
  #   template = github_repository.svc_template_rust.name
  #   default_branch_protection_settings = {} # Using module defaults
  # }
  svc_repos = {
    "storage" = {
      description = "Storage module"
    }
  }
}

module "svc_repository" {
  source   = "./modules/github-repository/"
  for_each = local.svc_repos

  name        = format("svc-%s", each.key)
  description = format("Arrow Services - %s", each.value.description)

  # Settings with defaults
  owner_team     = try(each.value.owner_team, "services")
  visibility     = try(each.value.visibility, "public")
  default_branch = try(each.value.default_branch, "develop")
  template       = try(each.value.template, github_repository.svc_template_rust.name)

  default_branch_protection_settings = try(each.value.default_branch_protection_settings, {})
}
