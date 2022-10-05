#####################################################################
#
# Repository settings for Arrow Templates
#
#####################################################################

locals {
  lib_template = {
    repos = {
      "rust" = {
        description = "Rust libraries"
        files = merge(
          local.rust_lib.files,
          { for file, path in local.rust_lib.template_files :
            file => { content = templatefile(path, {
              owner_team = "services"
              type       = "lib"
              name       = "lib-rust"
              port       = ""
              }
          ) } }
        )
      }
    }
  }

  svc_template = {
    repos = {
      "typescript" = {
        description    = "TypeScript services"
        files          = local.files
        template_files = local.template_files
      }
      "rust" = {
        files          = local.rust_svc.files
        template_files = local.rust_svc.template_files
        description    = "Rust services"
      }
      "python" = {
        description    = "Python services"
        files          = local.files
        template_files = local.template_files
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
# Library repositories
########################################################
module "repository_lib_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.lib_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("lib-template-%s", each.key)
  description = format("Arrow Library Template - %s", each.value.description)
  is_template = true

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  repository_files = merge(
    try(each.value.files, {}),
    { for file, path in local.template_files :
      file => { content = templatefile(path, { owner_team = each.value.owner_team, name = format("lib-template-%s", each.key) }) }
    }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Services repositories
########################################################
module "repository_svc_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.svc_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("svc-template-%s", each.key)
  description = format("Arrow Service Template - %s", each.value.description)
  is_template = true

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  repository_files = merge(
    try(each.value.files, {}),
    { for file, path in try(each.value.template_files, {}) :
      file => { content = templatefile(path, {
        owner_team = each.value.owner_team
        type       = "svc"
        name       = format("svc-template-%s", each.key)
        port       = 8080
        }
    ) } }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
