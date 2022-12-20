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
        files = merge(local.files, {
          ".github/workflows/terraform.yml" = {
            content = file("templates/tf-onboarding/.github/workflows/terraform.yml")
          }
        })
        visibility = "private"
      }
      "github" = {
        description = "github resources"
        files = merge(local.files, {
          ".github/workflows/terraform.yml" = {
            content = file("templates/tf-github/.github/workflows/terraform.yml")
          }
        })
      }
      "gcp-organization" = {
        description = "GCP Organization management"
      }
      "gcp-projects" = {
        description = "GCP Project management"
      }
      "gcp-network" = {
        description = "GCP Network management"
      }
    }
  }

  terraform_default = {
    template_files = merge(local.template_files, {
      "Makefile" = "templates/tf-all/Makefile"
    })

    files = merge(local.files, {
      ".github/workflows/terraform.yml" = {
        content = file("templates/tf-all/.github/workflows/terraform.yml")
      }
      ".gitignore" = {
        content = file("templates/tf-all/.gitignore")
      }
      ".make/terraform.mk" = {
        content = file("templates/all/.make/terraform.mk")
      }
    })

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
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    local.terraform_default.files,
    { for file, path in local.terraform_default.template_files :
      file => { content = templatefile(path, { owner_team = each.value.owner_team, name = format("tf-%s", each.key) }) }
    }
  )

  collaborators = {
    maintainers = ["services"]
  }

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
