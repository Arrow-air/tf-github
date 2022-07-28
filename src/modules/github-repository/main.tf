locals {
  # Make sure we add our default branch to the list of protected branches
  protected_branches = merge(
    {
      (var.default_branch) = var.default_branch_protection_settings
    },
    var.protected_branches
  )
}

data "github_team" "owner" {
  slug = var.owner_team
}

resource "github_repository" "repository" {
  name                   = var.name
  description            = var.description
  visibility             = var.visibility
  is_template            = var.is_template
  delete_branch_on_merge = var.delete_branch_on_merge

  auto_init            = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true

  dynamic "template" {
    for_each = var.template == null ? [] : [var.template]

    content {
      owner      = "Arrow-air"
      repository = template.key
    }
  }
}

########################################################
#
# Assign team access
#
########################################################
resource "github_team_repository" "admin" {
  for_each = var.collaborators.admins

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "admin"
}

resource "github_team_repository" "maintainer" {
  for_each = toset(distinct(concat([data.github_team.owner.name], tolist(var.collaborators.maintainers))))

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "maintain"
}

resource "github_team_repository" "puller" {
  for_each = var.collaborators.pullers

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "pull"
}

resource "github_team_repository" "pusher" {
  for_each = var.collaborators.pushers

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "push"
}

########################################################
#
# Create long lived branches
#
########################################################
resource "github_branch" "branch" {
  for_each = setsubtract(keys(local.protected_branches), ["main"])

  repository = github_repository.repository.name
  branch     = each.key
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = var.default_branch

  depends_on = [github_branch.branch]
}

resource "github_branch_protection" "protection" {
  for_each = { for key, value in local.protected_branches : key => merge(var.default_branch_protection_settings, value) }

  repository_id                   = github_repository.repository.name
  pattern                         = try(each.value.pattern, null) == null ? each.key : each.value.pattern
  enforce_admins                  = each.value.enforce_admins
  allows_deletions                = each.value.allows_deletions
  require_conversation_resolution = each.value.require_conversation_resolution
  require_signed_commits          = each.value.require_signed_commits

  push_restrictions = each.value.push_restrictions

  required_status_checks {
    strict = each.value.required_status_checks.strict
  }

  dynamic "required_pull_request_reviews" {
    for_each = toset(var.visibility == "public" ? ["rules"] : [])

    content {
      dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
      restrict_dismissals             = each.value.required_pull_request_reviews.restrict_dismissals
      require_code_owner_reviews      = each.value.required_pull_request_reviews.require_code_owner_reviews
      required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
      dismissal_restrictions          = each.value.required_pull_request_reviews.dismissal_restrictions
      pull_request_bypassers          = each.value.required_pull_request_reviews.pull_request_bypassers
    }
  }

  depends_on = [
    github_branch.branch,
    github_repository_environment.env,
    github_repository_file.CODEOWNERS
  ]
}

########################################################
#
# Create environments 
#
########################################################
resource "github_repository_environment" "env" {
  for_each = var.environments

  environment = each.key
  repository  = github_repository.repository.name

  dynamic "reviewers" {
    for_each = each.value.reviewers

    content {
      teams = data.github_team.reviewers[each.key].*.id
    }
  }

  deployment_branch_policy {
    protected_branches     = each.value.deployment_branch_policy.protected_branches
    custom_branch_policies = each.value.deployment_branch_policy.custom_branch_policies
  }
}

########################################################
#
# Provision CODEOWNERS file
#
########################################################
resource "github_repository_file" "CODEOWNERS" {
  repository          = github_repository.repository.name
  branch              = github_branch_default.default.branch
  file                = ".github/CODEOWNERS"
  content             = format("* @Arrow-air/%s\n", data.github_team.owner.name)
  commit_message      = "Provisioned by Terraform"
  commit_email        = "automation@arrowair.com"
  commit_author       = "Arrow automation"
  overwrite_on_create = true
  depends_on          = [github_repository_environment.env]
}
