#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  rust_lib = {
    files = merge(
      local.rust_default.files,
      {
        ".gitignore" = {
          content = file("templates/rust-lib/.gitignore")
        }
      }
    )

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
    files = merge(
      local.rust_default.files,
      {
        ".gitignore" = {
          content = file("templates/rust-svc/.gitignore")
        }
      }
    )

    repos = {
      "storage" = {
        description = "Storage module"
      },
      "scheduler" = {
        description = "Fleet Routing and Flight Planner"
      }
    }
  }

  rust_default = {
    files = {
      ".editorconfig" = {
        content = file("templates/rust-all/.editorconfig")
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
      ".github/workflows/editorconfig_check.yml" = {
        content = file("templates/rust-all/.github/workflows/editorconfig_check.yml")
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

  name             = format("lib-%s", each.key)
  description      = format("Arrow Library - %s", each.value.description)
  template         = module.repository_lib_template["rust"].repository.name
  repository_files = local.rust_lib.files

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

  name             = format("svc-%s", each.key)
  description      = format("Arrow Service - %s", each.value.description)
  template         = module.repository_svc_template["rust"].repository.name
  repository_files = local.rust_svc.files

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
