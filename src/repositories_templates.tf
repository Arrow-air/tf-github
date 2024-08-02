#####################################################################
#
# Repository settings for Arrow Templates
#
#####################################################################

locals {
  emb_template = {
    repos = {
      "stm32" = {
        files                              = local.stm32.files
        template_files                     = local.stm32.template_files
        description                        = "STM32 Projects"
        owner_team                         = "embedded"
        visibility                         = "public"
        default_branch                     = "develop"
        webhooks                           = try(local.webhooks["embedded"], {})
        default_branch_protection_settings = {} # Using module defaults
      }
    }
  }

  pod_template = {
    repos = {

      # Attempting "default" template; may specialize later
      "project" = {
        files          = local.pod-projects.files
        template_files = local.pod-projects.template_files
        description    = "Arrow Air Pod Projects"
        owner_team     = "drone-engineering"
        visibility     = "public"
        default_branch = "main"
        # webhooks                           = try(local.webhooks["embedded"], {})
        default_branch_protection_settings = {} # Using module defaults
      }
    }
  }

  template_default = {
    settings = {
      owner_team                         = "services"
      visibility                         = "public"
      default_branch                     = "develop"
      webhooks                           = try(local.webhooks["services"], {})
      default_branch_protection_settings = {} # Using module defaults
    }
  }
}

########################################################
# Embedded repositories
########################################################
module "repository_emb_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.emb_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("embedded-template-%s", each.key)
  description = format("Arrow Embedded Template - %s", each.value.description)
  is_template = true

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    try(each.value.files, {}),
    { for file, path in try(each.value.template_files, {}) :
      file => { content = templatefile(path, {
        owner_team = each.value.owner_team
        name       = format("embedded-template-%s", each.key)
        }
    ) } }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
}


########################################################
# Arrow Air Pod repositories
########################################################
module "repository_pod_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.pod_template.repos : key => merge(local.template_default.settings, settings) } # configure

  name        = format("pod-template-%s", each.key)                               # configure
  description = format("Arrow Project Pod Template - %s", each.value.description) # configure
  is_template = true

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    try(each.value.files, {}),
    { for file, path in try(each.value.template_files, {}) :
      file => { content = templatefile(path, {
        owner_team = each.value.owner_team
        name       = format("pod-template-%s", each.key) # configure
        }
    ) } }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
