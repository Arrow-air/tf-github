#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  rust_lib = {
    template_files = local.rust_default.template_files
    files          = local.rust_default.files

    repos = {
      "router" = {
        description = "Fleet Routing Algorithm Library"
      }
      #   "analytics" = {
      #     description = "Fleet Routing Analysis from Real or Simulated Artifacts"
      #   }
    }
  }

  rust_svc = {
    template_files = local.rust_default.template_files
    files          = local.rust_default.files

    repos = {
      "storage" = {
        description = "Storage module"
      },
      "scheduler" = {
        description = "Fleet Routing and Flight Planner"
      },
      "cargo" = {
        description = "Public Requests for Cargo Services"
      }
      "pricing" = {
        description = "Module for Pricing Flight Services"
      }
    }
  }

  rust_default = {
    template_files = merge(local.template_files, {
      "Makefile"   = "templates/rust-all/Makefile.tftpl"
      ".gitignore" = "templates/rust-all/.gitignore.tftpl"
    })

    files = {
      ".editorconfig" = {
        content = file("templates/rust-all/.editorconfig")
      },
      ".cspell.config.yaml" = {
        content = file("templates/rust-all/.cspell.config.yaml")
      },
      ".taplo.toml" = {
        content = file("templates/rust-all/.taplo.toml")
      },
      ".cargo/config.toml" = {
        content = file("templates/rust-all/.cargo/config.toml")
      },
      ".cargo-husky/hooks/pre-commit" = {
        content = file("templates/rust-all/.cargo-husky/hooks/pre-commit")
      },
      ".cargo-husky/hooks/pre-push" = {
        content = file("templates/rust-all/.cargo-husky/hooks/pre-push")
      },
      ".cargo-husky/hooks/README.md" = {
        content = file("templates/rust-all/.cargo-husky/hooks/README.md")
      },
      ".github/workflows/rust_ci.yml" = {
        content = file("templates/rust-all/.github/workflows/rust_ci.yml")
      },
      ".github/workflows/python_ci.yml" = {
        content = file("templates/rust-all/.github/workflows/python_ci.yml")
      },
      ".github/workflows/sanity_checks.yml" = {
        content = file("templates/rust-all/.github/workflows/sanity_checks.yml")
      },
      ".github/workflows/pr_rebase.yml" = {
        content = file("templates/rust-all/.github/workflows/pr_rebase.yml")
      }
    }

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
# Rust Library repositories
########################################################
module "repository_rust_lib" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.rust_lib.repos : key => merge(local.rust_default.settings, settings) }

  name        = format("lib-%s", each.key)
  description = format("Arrow Library - %s", each.value.description)
  template    = module.repository_lib_template["rust"].repository.name
  repository_files = merge(
    local.rust_lib.files,
    { for file, path in local.rust_lib.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          type       = "lib"
          name       = format("lib-%s", each.key)
          port       = ""
        })
      }
    }
  )

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Rust Services repositories
########################################################
module "repository_rust_svc" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.rust_svc.repos : key => merge(local.rust_default.settings, settings) }

  name        = format("svc-%s", each.key)
  description = format("Arrow Service - %s", each.value.description)
  template    = module.repository_svc_template["rust"].repository.name
  repository_files = merge(
    local.rust_svc.files,
    { for file, path in local.rust_svc.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          type       = "svc"
          name       = format("lib-%s", each.key)
          port       = format("80%02.0f", index(keys(local.rust_svc.repos), each.key))
        })
      }
    }
  )

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
