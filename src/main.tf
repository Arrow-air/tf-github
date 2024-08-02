data "github_app" "arrow_tf_github_repositories" {
  slug = "arrow-tf-github-repositories"
}

locals {
  arrow_release_automation_node_id = data.github_app.arrow_tf_github_repositories.node_id
  # Secret provided by Terraform Cloud configuration on the workspace
  discord_services_integration_url = sensitive(var.discord_services_integration_url)

  # List of webhooks to apply for repositories owned by team
  webhooks = {
    services = {
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
  }

  files = {
    ".github/workflows/sanity_checks.yml" = {
      content = file("templates/all/.github/workflows/sanity_checks.yml")
    },
    ".editorconfig" = {
      content = file("templates/all/.editorconfig")
    },
    ".commitlintrc.yml" = {
      content = file("templates/all/.commitlintrc.yml")
    },
    ".cspell.config.yaml" = {
      content = file("templates/all/.cspell.config.yaml")
    },
    ".make/base.mk" = {
      content = file("templates/all/.make/base.mk")
    },
    ".make/cspell.mk" = {
      content = file("templates/all/.make/cspell.mk")
    },
    ".make/commitlint.mk" = {
      content = file("templates/all/.make/commitlint.mk")
    },
    ".make/editorconfig.mk" = {
      content = file("templates/all/.make/editorconfig.mk")
    },
    ".make/markdown.mk" = {
      content = file("templates/all/.make/markdown.mk")
    },
    "CONTRIBUTING.md" = {
      content = file("templates/all/CONTRIBUTING.md")
    },
  }
  template_files = {
    ".github/CODEOWNERS" = "templates/all/.github/CODEOWNERS.tftpl"
    "Makefile"           = "templates/all/Makefile"
  }

  repos = {
    "HearHear" = {
      description = "Backend for HearHear Discord bot."
      visibility  = "public"
      owner_team  = "services"
    }
    "HearHear-Webapp" = {
      description = "Frontend for HearHear."
      visibility  = "public"
      owner_team  = "services"
    }
    "website" = {
      default_branch = "staging"
      description    = "Arrowair website and documentation with Docusaurus"
      visibility     = "public"
      owner_team     = "webdevelopers"
    }
    "cla-bot" = {
      description = "Arrow CLA bot API code and deployment files"
      visibility  = "public"
      owner_team  = "devops"
    }
    "clabot-config" = {
      description = "Arrow CLA bot global configuration"
      visibility  = "private"
      owner_team  = "devops"
      # override review_count for branch protection settings
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          required_approving_review_count = 2
        }
      }
    }
    "tools" = {
      description = "Software used for Arrow engineering"
      visibility  = "public"
      owner_team  = "devops"
      webhooks    = try(local.webhooks["services"], {})
      repository_files = {
        ".github/CODEOWNERS" = {
          content = file("templates/tools/.github/CODEOWNERS")
        }
      }
      collaborators = {
        maintainers = ["services", "drone-engineering"]
      }
    }
    "dao-gbc" = {
      default_branch = "main"
      description    = "Arrowair Grants and Bounties Committee"
      visibility     = "public"
      owner_team     = "services"
    }
    "dao-governance" = {
      default_branch = "main"
      description    = "Arrowair DAO governance"
      visibility     = "public"
      owner_team     = "services"
    }
  }
}

module "repository" {
  source   = "./modules/github-repository/"
  for_each = local.repos

  name                  = each.key
  description           = each.value.description
  visibility            = each.value.visibility
  default_branch        = try(each.value.default_branch, "main")
  webhooks              = try(each.value.webhooks, {})
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    local.files,
    { for file, path in local.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          name       = each.key
        })
      }
    },
    try(each.value.repository_files, {})
  )

  collaborators = try(each.value.collaborators, {})

  default_branch_protection_settings = try(each.value.default_branch_protection_settings, {})

  owner_team = each.value.owner_team
  template   = try(each.value.template, null)
}
