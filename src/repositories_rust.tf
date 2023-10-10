#####################################################################
#
# Repository settings for Arrow Services
#
#####################################################################
locals {
  rust_lib = {
    template_files = merge(local.rust_default.template_files, {
      ".env.base" = "templates/rust-lib/.env.base.tftpl"
      "Makefile"  = "templates/rust-lib/Makefile"
    })
    files = merge(
      local.rust_default.files, {
        ".github/workflows/post_release.yml" = {
          content = file("templates/rust-lib/.github/workflows/post_release.yml")
        }
      }
    )

    repos = {
      "router" = {
        archived    = "true",
        description = "Fleet Routing Algorithm Library"
      }
      "common" = {
        description = "Common functions and data types for Arrow services."
        variables = {
          "RELEASE_COMMIT_FILES" = ".terraform_init lib/Cargo.toml arrow-macros/**/Cargo.toml CHANGELOG.md"
        }
      }
      "ccsds" = {
        description = "CCSDS Space Packet Protocol in Rust."
      }
    }
  }

  rust_svc = {
    environments = {
      production = {
        branch = "main"
        secrets = {
          "AWS_S3_SERVICES_DOCS_BUCKET" = "arrow-prd-services-docs"
          "AWS_S3_SERVICES_DOCS_ROLE"   = "prd-GitHubActionsDocs"
        }
      }
    }
    variables = {
      "RELEASE_COMMIT_FILES" = ".terraform_init Cargo.lock client-*/Cargo.toml server/Cargo.toml CHANGELOG.md"
    }
    template_files = merge(local.rust_default.template_files, {
      ".env.base" = "templates/rust-svc/.env.base.tftpl"
      "Makefile"  = "templates/rust-svc/Makefile"
    })
    files = merge(
      local.rust_default.files, {
        "Dockerfile" = {
          content = file("templates/rust-svc/Dockerfile")
        }
        ".dockerignore" = {
          content = file("templates/rust-svc/.dockerignore")
        }
        "docker-compose.yml" = {
          content = file("templates/rust-svc/docker-compose.yml")
        }
        ".github/workflows/post_release.yml" = {
          content = file("templates/rust-svc/.github/workflows/post_release.yml")
        }
        ".github/workflows/api_docs.yml" = {
          content = file("templates/rust-svc/.github/workflows/api_docs.yml")
        }
      }
    )

    repos = {
      "storage" = {
        description = "Storage module"
        # Override files list to provision with Terraform
        # svc-storage handles its own docker-compose.yml file
        # due to extra backend services needed
        files = merge(
          local.rust_default.files, {
            "Dockerfile" = {
              content = file("templates/rust-svc/Dockerfile")
            }
            ".dockerignore" = {
              content = file("templates/rust-svc/.dockerignore")
            }
            ".github/workflows/autosquash.yml" = {
              content = file("templates/rust-all/.github/workflows/autosquash.yml")
            }
            ".github/workflows/release.yml" = {
              content = file("templates/rust-all/.github/workflows/release.yml")
            }
            ".github/workflows/post_release.yml" = {
              content = file("templates/rust-svc/.github/workflows/post_release.yml")
            }
            ".github/workflows/api_docs.yml" = {
              content = file("templates/rust-svc/.github/workflows/api_docs.yml")
            }
          }
        )
      }
      "scheduler" = {
        description = "Fleet Routing and Flight Planner"
      }
      "cargo" = {
        description = "Public Requests for Cargo Services"
      }
      "contact" = {
        description = "Forward communications to external email and SMS services."
      }
      "docs" = {
        description = "Generate and manage external and internal documents."
      }
      "discovery" = {
        description = "Coordination with other service providers and U-space."
      }
      "pricing" = {
        description = "Module for Pricing Flight Services"
      }
      "compliance" = {
        description = "Communication with external regulatory bodies."
        # Override files list to provision with Terraform
        # svc-compliance handles its own post_release file
        # due to region specific docker builds
        files = merge(
          local.rust_default.files, {
            "Dockerfile" = {
              content = file("templates/rust-svc/Dockerfile")
            }
            ".dockerignore" = {
              content = file("templates/rust-svc/.dockerignore")
            }
            "docker-compose.yml" = {
              content = file("templates/rust-svc/docker-compose.yml")
            }
            ".github/workflows/autosquash.yml" = {
              content = file("templates/rust-all/.github/workflows/autosquash.yml")
            }
            ".github/workflows/release.yml" = {
              content = file("templates/rust-all/.github/workflows/release.yml")
            }
            ".github/workflows/api_docs.yml" = {
              content = file("templates/rust-svc/.github/workflows/api_docs.yml")
            }
          }
        )

      }
      "assets" = {
        description = "Registration and management of network assets."
      }
      "atc" = {
        description = "Automated air traffic control for integrated airspace."
      }
      "telemetry" = {
        description = "Receive and rebroadcast vehicle and vertiport telemetry."
        # Override files list to provision with Terraform
        # svc-telemetry handles its own docker-compose.yml file
        # due to extra backend services needed
        files = merge(
          local.rust_default.files, {
            "Dockerfile" = {
              content = file("templates/rust-svc/Dockerfile")
            }
            ".dockerignore" = {
              content = file("templates/rust-svc/.dockerignore")
            }
            ".github/workflows/autosquash.yml" = {
              content = file("templates/rust-all/.github/workflows/autosquash.yml")
            }
            ".github/workflows/release.yml" = {
              content = file("templates/rust-all/.github/workflows/release.yml")
            }
            ".github/workflows/post_release.yml" = {
              content = file("templates/rust-svc/.github/workflows/post_release.yml")
            },
            ".github/workflows/api_docs.yml" = {
              content = file("templates/rust-svc/.github/workflows/api_docs.yml")
            }
          }
        )
      }
      "gis" = {
        description = "Gateway to the Airspace Geoinformation Database"
        # Override files list to provision with Terraform
        # svc-gis handles its own docker-compose.yml file
        # due to extra backend services needed (PostGIS)
        files = merge(
          local.rust_default.files, {
            "Dockerfile" = {
              content = file("templates/rust-svc/Dockerfile")
            }
            ".dockerignore" = {
              content = file("templates/rust-svc/.dockerignore")
            }
            ".github/workflows/autosquash.yml" = {
              content = file("templates/rust-all/.github/workflows/autosquash.yml")
            }
            ".github/workflows/release.yml" = {
              content = file("templates/rust-all/.github/workflows/release.yml")
            }
            ".github/workflows/post_release.yml" = {
              content = file("templates/rust-svc/.github/workflows/post_release.yml")
            }
            ".github/workflows/api_docs.yml" = {
              content = file("templates/rust-svc/.github/workflows/api_docs.yml")
            }
          }
        )
      }
      "devops-test" = {
        description = "Repository used by devops to test workflows before rolling out to all other svc repositories"
        webhooks    = {}
      }
      "itest" = {
        description = "Repository for integration testing of the Arrow backend services."
        webhooks    = {}
      }
    }
  }

  rust_default = {
    template_files = merge(local.template_files, {
      ".gitignore" = "templates/rust-all/.gitignore.tftpl"
      "LICENSE"    = "templates/rust-all/LICENSE.tftpl"
    })

    files = merge(local.files, {
      ".make/docker.mk" = {
        content = file("templates/all/.make/docker.mk")
      }
      ".make/env.mk" = {
        content = file("templates/all/.make/env.mk")
      }
      ".make/python.mk" = {
        content = file("templates/all/.make/python.mk")
      }
      ".make/rust.mk" = {
        content = file("templates/all/.make/rust.mk")
      }
      ".make/toml.mk" = {
        content = file("templates/all/.make/toml.mk")
      }
      ".taplo.toml" = {
        content = file("templates/rust-all/.taplo.toml")
      }
      ".cargo/config.toml" = {
        content = file("templates/rust-all/.cargo/config.toml")
      }
      ".cargo-husky/hooks/pre-commit" = {
        content = file("templates/rust-all/.cargo-husky/hooks/pre-commit")
      }
      ".cargo-husky/hooks/pre-push" = {
        content = file("templates/rust-all/.cargo-husky/hooks/pre-push")
      }
      ".cargo-husky/hooks/commit-msg" = {
        content = file("templates/rust-all/.cargo-husky/hooks/commit-msg")
      }
      ".cargo-husky/hooks/README.md" = {
        content = file("templates/rust-all/.cargo-husky/hooks/README.md")
      }
      ".github/workflows/rust_ci.yml" = {
        content = file("templates/rust-all/.github/workflows/rust_ci.yml")
      }
      ".github/workflows/python_ci.yml" = {
        content = file("templates/rust-all/.github/workflows/python_ci.yml")
      }
      ".github/workflows/sanity_checks.yml" = {
        content = file("templates/rust-all/.github/workflows/sanity_checks.yml")
      }
      ".github/workflows/nightly.yml" = {
        content = file("templates/rust-all/.github/workflows/nightly.yml")
      }
      ".github/workflows/release.yml" = {
        content = file("templates/rust-all/.github/workflows/release.yml")
      }
      ".github/workflows/autosquash.yml" = {
        content = file("templates/rust-all/.github/workflows/autosquash.yml")
      }
    })

    settings = {
      owner_team     = "services"
      visibility     = "public"
      default_branch = "develop"
      webhooks       = try(local.webhooks["services"], {})
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          pull_request_bypassers = ["/arrow-github-bot"]
        }
      }
      protected_branches = {
        "main" = {
          required_pull_request_reviews = {
            pull_request_bypassers = ["/arrow-github-bot"]
          }
        }
      }
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
          port_rest  = ""
          port_grpc  = ""
        })
      }
    }
  )

  variables = merge(local.rust_svc.variables, try(each.value.variables, {}))
  archived  = try(each.value.archived, false)

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  default_branch_protection_settings = each.value.default_branch_protection_settings
  protected_branches                 = each.value.protected_branches
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
    try(each.value.files, local.rust_svc.files),
    { for file, path in local.rust_svc.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          type       = "svc"
          name       = format("svc-%s", each.key)
          port_rest  = format("80%02.0f", index(keys(local.rust_svc.repos), each.key))
          port_grpc  = format("500%02.0f", index(keys(local.rust_svc.repos), each.key))
        })
      }
    }
  )

  environments = local.rust_svc.environments
  variables    = merge(local.rust_svc.variables, try(each.value.variables, {}))
  archived     = try(each.value.archived, false)

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  default_branch_protection_settings = each.value.default_branch_protection_settings
  protected_branches                 = each.value.protected_branches
}
