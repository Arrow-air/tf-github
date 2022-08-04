#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  lib = {
    repository_prefix  = "lib"
    description_prefix = "Arrow Libraries"

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

    lib_files = {
      ".gitignore" = {
        content = file("templates/rust-lib/.gitignore")
      },
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

    # List of service repositories to be created
    # Default settings without override
    # {
    #   name           = "<repository_prefix>-<lib_template_repos key>"
    #   description    = "<description_prefix> - <description>"
    # }
    # Default settings (can be overwritten here)
    # {
    #   owner_team     = "services"
    #   visibility     = "public"
    #   default_branch = "dev"
    #   template       = github_repository.lib_template_rust.name
    #   webhooks       = local.lib.webhooks
    #   default_branch_protection_settings = {} # Using module defaults
    # }
    repos = {
      #   "router" = {
      #     description = "Fleet Routing Algorithm Library"
      #   }
      #   "analytics" = {
      #     description = "Fleet Routing Analysis from Real or Simulated Artifacts"
      #   }
    }
  }
}

########################################################
# Services repositories
########################################################
module "lib_repository" {
  source   = "./modules/github-repository/"
  for_each = local.lib.repos

  name        = format("%s-%s", local.lib.repository_prefix, each.key)
  description = format("%s - %s", local.lib.description_prefix, each.value.description)

  # Settings with defaults
  owner_team       = try(each.value.owner_team, "services")
  visibility       = try(each.value.visibility, "public")
  default_branch   = try(each.value.default_branch, "develop")
  template         = github_repository.lib_template_rust.name
  webhooks         = local.lib.webhooks
  repository_files = local.lib.lib_files

  default_branch_protection_settings = try(each.value.default_branch_protection_settings, {})
}
