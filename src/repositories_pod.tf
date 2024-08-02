#####################################################################
#
# Repository settings for Pod Projects
#
#####################################################################
locals {
  pod-projects = {
    template_files = merge(local.template_files, {
      #   ".env.base"          = "templates/stm32-all/.env.base.tftpl",
      #   "Makefile"           = "templates/stm32-all/Makefile",
      #   ".github/CODEOWNERS" = "templates/all/.github/CODEOWNERS.tftpl"
    })

    files = merge(local.files, {
      #   ".gitignore" = {
      #     content = file("templates/stm32-all/.gitignore")
      #   }
      "src/readme.md" = {
        content = file("templates/pod-project/readme-src.md")
      }
      "docs/mkdocs.yaml" = {
        content = file("templates/pod-project/mkdocs.yaml")
      }
      "docs/ADRs/template-adr.md" = {
        content = file("templates/pod-project/template-adr.md")
      }
      "docs/meetings/template-meeting.md" = {
        content = file("templates/pod-project/template-meeting.md")
      }
    })

    repos = {
      # "feather" = {
      #   description = "Project Feather documentation, designs, and project artifacts."
      #   webhooks    = {}
      # }
    }

    settings = {
      owner_team     = "drone-engineering"
      visibility     = "public"
      default_branch = "main"
      #   webhooks       = try(local.webhooks["embedded"], {})
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          pull_request_bypassers = ["/arrow-github-bot"]
        }
      }
    }
  }
}

########################################################
# Arrow Air Pod Projects
########################################################
module "repository_pod" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.pod-projects.repos : key => settings } # config

  name        = format("project-%s", each.key)
  description = format("%s", each.value.description)
  template    = module.repository_pod_template["project"].repository.name # config
  repository_files = merge(
    local.pod-projects.files,                               # config
    { for file, path in local.pod-projects.template_files : # config
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
