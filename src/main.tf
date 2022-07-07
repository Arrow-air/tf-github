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
      visibility  = "public"
      owner_team  = "devops"
    }
    "clabot-config" = {
      description                     = "Arrow CLA bot global configuration"
      visibility                      = "private"
      owner_team                      = "devops"
      required_approving_review_count = 2
    }
    "tools" = {
      description                     = "Software used for Arrow engineering"
      visibility                      = "public"
      owner_team                      = "drone-engineering"
      required_approving_review_count = 1
    }
    "svc-storage" = {
      description                     = "Arrow Services Storage module"
      visibility                      = "public"
      owner_team                      = "services"
      required_approving_review_count = 1
      template                        = github_repository.svc_template_rust.name
    }
  }
}

output "branches" {
  value = module.repository
}

module "repository" {
  source   = "./modules/github-repository/"
  for_each = local.repos

  name           = each.key
  description    = each.value.description
  visibility     = each.value.visibility
  default_branch = try(each.value.default_branch, null)

  required_approving_review_count = try(each.value.required_approving_review_count, 1)

  owner_team = each.value.owner_team
}
