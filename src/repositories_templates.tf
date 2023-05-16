#####################################################################
#
# Repository settings for Arrow Templates
#
#####################################################################

locals {
  lib_template = {
    repos = {
      "rust" = {
        description    = "Rust libraries"
        files          = local.rust_lib.files
        template_files = local.rust_lib.template_files
      }
    }
  }

  svc_template = {
    repos = {
      "rust" = {
        files          = local.rust_svc.files
        variables      = local.rust_svc.variables
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

  web_template = {
    settings = {
      owner_team = "webdevelopers"
    }
    repos = {
      "nuxt" = {
        description    = "Nuxt Web Applications"
        files          = local.files
        template_files = local.template_files
      }
    }
  }

  mod_template = {
    settings = {
      owner_team = "webdevelopers"
    }
    repos = {
      "nuxt" = {
        description    = "Nuxt Modules"
        files          = local.files
        template_files = local.template_files
      }
    }
  }

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
        type       = "lib"
        name       = format("lib-template-%s", each.key)
        port_rest  = ""
        port_grpc  = ""
        }
    ) } }
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
        type       = "svc"
        name       = format("svc-template-%s", each.key)
        port_rest  = 8080  # arbitrary, template files not used in prod
        port_grpc  = 50051 # arbitrary, template files not used in prod
        }
    ) } }
  )

  variables = try(each.value.variables, {})

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Web Application repositories
########################################################
module "repository_web_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.web_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("web-template-%s", each.key)
  description = format("Arrow Web Application Template - %s", each.value.description)
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
        type       = "web"
        name       = format("web-template-%s", each.key)
        port_rest  = ""
        port_grpc  = ""
        }
    ) } }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Module repositories
########################################################
module "repository_mod_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.mod_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("mod-template-%s", each.key)
  description = format("Arrow Module Template - %s", each.value.description)
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
        type       = "mod"
        name       = format("mod-template-%s", each.key)
        port_rest  = ""
        port_grpc  = ""
        }
    ) } }
  )

  default_branch_protection_settings = each.value.default_branch_protection_settings
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
