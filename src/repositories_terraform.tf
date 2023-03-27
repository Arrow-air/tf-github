#####################################################################
#
# Repository settings for Arrow Terraform
#
#####################################################################
locals {
  # Repositories needed for shared Terraform Modules can be listed here
  tf_mod = {
    files = local.terraform_default.files

    # Using Terraform naming convention for modules
    repos = {
      "google-automation-setup" = {
        description = "Automation resources"
      }
    }
  }

  # Repositories deploying infra to GCP
  tf_gcp = {
    template_files = {
      ".env.base" = "templates/tf-gcp/.env.base.tftpl"
      "Makefile"  = "templates/tf-gcp/Makefile"
    }

    files = {
      ".github/workflows/terraform.yml" = {
        content = file("templates/tf-gcp/.github/workflows/terraform.yml")
      }
      ".make/env.mk" = {
        content = file("templates/all/.make/env.mk")
      }
    }

    repos = {
      "organization" = {
        description = "GCP Organization management"
        project     = "org"
      }
      "projects" = {
        description = "GCP Project management"
        project     = "org"
      }
      "network" = {
        description = "GCP Network management"
        project     = "network"
      }
      "services-app" = {
        description = "GCP Services App infra management"
        project     = "app"
        owner_team  = "services"
      }
    }
  }

  tf = {
    repos = {
      "onboarding" = {
        description = "users and groups for resources manageable by Terraform"
        project     = "onboarding"
        files = {
          ".github/workflows/terraform.yml" = {
            content = file("templates/tf-onboarding/.github/workflows/terraform.yml")
          }
        }
        visibility = "private"
      }
      "github" = {
        description = "github resources"
        project     = "github"
        files = {
          ".github/workflows/terraform.yml" = {
            content = file("templates/tf-github/.github/workflows/terraform.yml")
          }
        }
      }
    }
  }

  terraform_default = {
    template_files = merge(local.template_files, {
      "Makefile" = "templates/tf-all/Makefile"
    })

    files = merge(local.files, {
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
    try(each.value.files, {}),
    { for file, path in local.terraform_default.template_files :
      file => { content = templatefile(path, { owner_team = each.value.owner_team, name = format("tf-%s", each.key), project = each.value.project }) }
    }
  )

  collaborators = {
    maintainers = ["services"]
  }

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# GCP Terraform repositories
########################################################
module "repository_tf_gcp" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.tf_gcp.repos : key => merge(local.terraform_default.settings, settings) }

  name        = format("tf-gcp-%s", each.key)
  description = format("Arrow Terraform - %s", each.value.description)

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    local.terraform_default.files,
    try(local.tf_gcp.files, {}),
    try(each.value.files, {}),
    { for file, path in merge(local.terraform_default.template_files, try(local.tf_gcp.template_files, {})) :
      file => { content = templatefile(path, {
        owner_team = each.value.owner_team
        name       = format("tf-gcp-%s", each.key)
        project    = each.value.project
      }) }
    }
  )

  collaborators = {
    maintainers = ["services"]
  }

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Terraform module repositories
########################################################
module "repository_tf_mod" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.tf_mod.repos : key => merge(local.terraform_default.settings, settings) }

  name        = format("terraform-%s", each.key)
  description = format("Arrow Terraform module - %s", each.value.description)

  # Settings with defaults
  owner_team            = each.value.owner_team
  visibility            = each.value.visibility
  default_branch        = each.value.default_branch
  webhooks              = each.value.webhooks
  terraform_app_node_id = local.arrow_release_automation_node_id

  repository_files = merge(
    local.terraform_default.files,
    try(local.tf_mod.files, {}),
    try(each.value.files, {}),
    { for file, path in merge(local.terraform_default.template_files, try(local.tf_mod.template_files, {})) :
      file => { content = templatefile(path, {
        owner_team = each.value.owner_team
        name       = format("terraform-%s", each.key)
      }) }
    }
  )

  collaborators = {
    maintainers = ["services"]
  }

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
