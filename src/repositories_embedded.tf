#####################################################################
#
# Repository settings for STM32 Projects
#
#####################################################################
locals {
  stm32 = {
    template_files = {
      ".env.base"          = "templates/stm32-all/.env.base.tftpl",
      "Makefile"           = "templates/stm32-all/Makefile",
      ".github/CODEOWNERS" = "templates/all/.github/CODEOWNERS.tftpl"
    }

    files = merge(local.files, {
      ".github/workflows/sanity_checks.yml" = {
        content = file("templates/all/.github/workflows/sanity_checks.yml"),
      },
      ".github/workflows/stm32_ci.yml" = {
        content = file("templates/stm32-all/.github/workflows/stm32_ci.yml"),
      },
      ".gitignore" = {
        content = file("templates/stm32-all/.gitignore")
      },
      ".github/workflows/release.yml" = {
        content = file("templates/stm32-all/.github/workflows/release.yml")
      },
      ".github/workflows/autoupdate.yml" = {
        content = file("templates/stm32-all/.github/workflows/autoupdate.yml")
      },
      ".make/env.mk" = {
        content = file("templates/all/.make/env.mk")
      },
      ".github/workflows/nightly.yml" = {
        content = file("templates/stm32-all/.github/workflows/nightly.yml")
      },
      ".make/st.mk" = {
        content = file("templates/stm32-all/.make/st.mk")
      }
    })

    repos = {
      # "devops-stm32-test" = {
      #  description = "Repository used by devops to test workflows before rolling out to all other stm32 repositories"
      #  webhooks    = {}
      # }
    }

    settings = {
      owner_team     = "embedded"
      visibility     = "public"
      default_branch = "develop"
      webhooks       = try(local.webhooks["embedded"], {})
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          pull_request_bypassers = ["/arrow-github-bot"]
        }
      }
    }
  }
}

########################################################
# STM32 Projects
########################################################
module "repository_stm32" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.stm32.repos : key => settings }

  name        = format("%s", each.key)
  description = format("%s", each.value.description)
  template    = module.repository_emb_template["stm32"].repository.name
  repository_files = merge(
    local.stm32.files,
    { for file, path in local.stm32.template_files :
      file => {
        content = templatefile(path, {
          owner_team = each.value.owner_team
          name       = each.key
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
