#####################################################################
#
# Repository settings for Arrow Web Applications
#
#####################################################################
locals {
  # Repositories needed for shared Nuxt Components can be listed here
  nuxt_mod = {
    template_files = local.nuxt_default.template_files
    files          = local.nuxt_default.files

    repos = {
    }
  }

  # Repositories needed for our Web Applications can be listed here
  nuxt_web = {
    template_files = local.nuxt_default.template_files
    files = merge(
      local.nuxt_default.files, {
        ".github/workflows/build-and-deploy.yml" = {
          content = file("templates/nuxt-web/.github/workflows/build-and-deploy.yml")
        }
        ".github/workflows/deploy-dmo.yml" = {
          content = file("templates/nuxt-web/.github/workflows/deploy-dmo.yml")
        }
        ".github/workflows/deploy-prd.yml" = {
          content = file("templates/nuxt-web/.github/workflows/deploy-prd.yml")
        }
        ".github/workflows/deploy-stg.yml" = {
          content = file("templates/nuxt-web/.github/workflows/deploy-stg.yml")
        }
        ".github/workflows/invalidate-cloudfront.yml" = {
          content = file("templates/nuxt-web/.github/workflows/invalidate-cloudfront.yml")
        }
      }
    )

    repos = {
      "cargo-shipper" = {
        description = "Cargo Shipper"
        variables = {
          "AWS_REGION" = "us-east-1"
          "DOMAIN"     = "flyarrow.io"
          "APP"        = "cargo"
        }
        environments = {
          production = {
            branch = "main"
            variables = {
              "ENVIRONMENT_ABBR"            = "prd"
              "AWS_CLOUDFRONT_DISTRIBUTION" = "E134L2OOWNMG4H"
            }
          }
          staging = {
            branch = "staging"
            variables = {
              "ENVIRONMENT_ABBR"            = "stg"
              "AWS_CLOUDFRONT_DISTRIBUTION" = "EVMCVI5OJORTD"
            }
          }
          demo = {
            variables = {
              "ENVIRONMENT_ABBR" = "dmo"
            }
          }
          dev = {
            variables = {
              "ENVIRONMENT_ABBR" = "dev"
            }
          }
        }
      }
      "services-hangar" = {
        description = "Asset management and administration UI"
      }
      "services-public" = {
        description = "Services landing page"
        variables = {
          "AWS_REGION" = "us-east-1"
          "DOMAIN"     = "flyarrow.io"
          "APP"        = "website"
        }
        environments = {
          production = {
            branch = "main"
            variables = {
              "ENVIRONMENT_ABBR"            = "prd"
              "AWS_CLOUDFRONT_DISTRIBUTION" = "E134L2OOWNMG4H"
            }
          }
          staging = {
            branch = "staging"
            variables = {
              "ENVIRONMENT_ABBR" = "stg"
            }
          }
          demo = {
            variables = {
              "ENVIRONMENT_ABBR" = "dmo"
            }
          }
          dev = {
            variables = {
              "ENVIRONMENT_ABBR" = "dev"
            }
          }
        }
      }
    }
  }

  nuxt_default = {
    template_files = merge(local.template_files, {
    })

    files = merge(local.files, {
      ".gitignore" = {
        content = file("templates/nuxt-all/.gitignore")
      }
      ".prettierrc.yaml" = {
        content = file("templates/nuxt-all/.prettierrc.yaml")
      }
      ".husky/pre-commit" = {
        content = file("templates/nuxt-all/.husky/pre-commit")
      }
      ".husky/commit-msg" = {
        content = file("templates/nuxt-all/.husky/commit-msg")
      }
      ".github/workflows/sanity_checks.yml" = {
        content = file("templates/nuxt-all/.github/workflows/sanity_checks.yml")
      }
      ".github/workflows/autosquash.yml" = {
        content = file("templates/nuxt-all/.github/workflows/autosquash.yml")
      }
    })

    settings = {
      owner_team                         = "webdevelopers"
      visibility                         = "public"
      default_branch                     = "develop"
      webhooks                           = try(local.webhooks["services"], {})
      default_branch_protection_settings = {} # Using module defaults
    }
  }
}

########################################################
# Rust Library repositories
########################################################
module "repository_nuxt_mod" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.nuxt_mod.repos : key => merge(local.nuxt_default.settings, settings) }

  name        = format("mod-%s", each.key)
  description = format("Arrow Nuxt Module - %s", each.value.description)
  template    = module.repository_mod_template["nuxt"].repository.name
  repository_files = merge(
    local.nuxt_mod.files,
    { for file, path in local.nuxt_mod.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          type       = "mod"
          name       = format("mod-%s", each.key)
        })
      }
    }
  )

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Rust Services repositories
########################################################
module "repository_nuxt_web" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.nuxt_web.repos : key => merge(local.nuxt_default.settings, settings) }

  name        = format("web-%s", each.key)
  description = format("Arrow Web Application - %s", each.value.description)
  template    = module.repository_web_template["nuxt"].repository.name
  repository_files = merge(
    local.nuxt_web.files,
    { for file, path in local.nuxt_web.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          type       = "web"
          name       = format("web-%s", each.key)
        })
      }
    }
  )


  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks
  variables      = try(each.value.variables, {})
  environments   = try(each.value.environments, {})

  terraform_app_node_id              = local.arrow_release_automation_node_id
  default_branch_protection_settings = each.value.default_branch_protection_settings
}
