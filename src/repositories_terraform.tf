#####################################################################
#
# Repository settings for Arrow Terraform
#
#####################################################################
locals {
  tf = {
    repos = {
      "onboarding" = {
        description = "users and groups for resources manageable by Terraform"
        visibility  = "private"
        owner_team  = "devops"
      }
      "github" = {
        description = "github resources"
      }
    }
  }

  terraform_default = {
    files = {
      ".editorconfig" = {
        content = file("templates/terraform/.editorconfig")
      }
    }

    settings = {
      owner_team     = "devops"
      visibility     = "public"
      default_branch = "main"
      webhooks       = try(local.webhooks["services"], {})
      # override review_count for branch protection settings
      default_branch_protection_settings = {
        required_pull_request_reviews = {
          required_approving_review_count = 2
        }
      }
    }
  }
}

########################################################
# Terraform repositories
########################################################
module "repository_tf" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.tf.repos : key => merge(local.terraform_default.settings, settings) }

  name        = format("tf-%s", each.key)
  description = format("Arrow Terraform - %s", each.value.description)

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  repository_files = merge(
    local.terraform_default.files,
    { for file, path in local.template_files :
      file => { content = templatefile(path, { owner_team = each.value.owner_team }) }
    }
  )

  collaborators = {
    maintainers = ["services"]
  }

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
