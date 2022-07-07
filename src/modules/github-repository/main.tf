locals {
  collaborators = merge(var.collaborators, {
    admins      = []
    maintainers = []
    pushers     = []
    pullers     = []
  })

  default_branch = var.default_branch == null ? "main" : var.default_branch

  branches = distinct(concat([local.default_branch], var.other_branches))
}

data "github_team" "owner" {
  slug = var.owner_team
}

resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  auto_init            = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true

  dynamic "template" {
    for_each = var.template == null ? {} : { owner = "Arrow-air", repository = var.template }

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }
}

########################################################
#
# Assign team access
#
########################################################
resource "github_team_repository" "admin" {
  for_each = toset(local.collaborators.admins)

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "admin"
}

resource "github_team_repository" "maintainer" {
  for_each = toset(distinct(concat([data.github_team.owner.name], local.collaborators.maintainers)))

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "maintain"
}

resource "github_team_repository" "puller" {
  for_each = toset(local.collaborators.pullers)

  repository = github_repository.repository.name
  team_id    = each.key
  permission = "pull"
}

resource "github_team_repository" "pusher" {
  for_each = toset(local.collaborators.pushers)

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
  for_each = setsubtract(local.branches, ["main"])

  repository = github_repository.repository.name
  branch     = each.key
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = local.default_branch

  depends_on = [github_branch.branch]
}

resource "github_branch_protection" "protection" {
  for_each = toset(var.visibility == "public" ? local.branches : [])

  repository_id                   = github_repository.repository.name
  pattern                         = each.key
  enforce_admins                  = each.key == "main" ? true : false
  allows_deletions                = false
  require_conversation_resolution = true
  push_restrictions               = []

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    require_code_owner_reviews      = true
    required_approving_review_count = var.required_approving_review_count
    dismissal_restrictions          = []
    pull_request_bypassers          = []
  }

  depends_on = [github_repository_environment.env, github_repository_file.CODEOWNERS]
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
  overwrite_on_create = false
  depends_on          = [github_repository_environment.env]
}
