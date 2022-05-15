locals {
  repos = {
    "website" = {
      default_branch = "staging"
      description    = "Arrowair website and documentation with Docusaurus"
      visibility     = "public"
      owner_team     = "webdevelopers"
    }
    "tf-github" = {
      description = "Terraform code to create github resources"
      visibility  = "private" # Not sure if we want to make this one public
      owner_team  = "devops"  # Will need to change this to a proper group
    }
    "tf-onboarding" = {
      description = "Terraform code to create users and groups for resources manageable by Terraform"
      visibility  = "private"
      owner_team  = "devops"
    }
    "cla-bot" = {
      description = "Arrow CLA bot API code and deployment files"
      visibility  = "private"
      owner_team  = "devops"
    }
    "clabot-config" = {
      description                     = "Arrow CLA bot global configuration"
      visibility                      = "public"
      owner_team                      = "devops"
      required_approving_review_count = 2
    }
  }
}

module "repository" {
  source   = "./modules/github-repository/"
  for_each = local.repos

  name           = each.key
  description    = each.value.description
  visibility     = each.value.visibility
  default_branch = each.value.default_branch

  required_approving_review_count = each.value.required_approving_review_count

  owner_team = each.value.owner_team
}
