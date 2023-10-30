locals {
  # Make sure we add our default branch to the list of protected branches
  protected_branches = merge(
    var.protected_branches,
    {
      (var.default_branch) = var.default_branch_protection_settings
    }
  )

  github_owner = var.github_owner
  start_branch = var.template == null ? "main" : data.github_repository.template[var.template].default_branch
}

data "github_repository" "template" {
  for_each  = toset(var.template == null ? [] : [var.template])
  full_name = format("%s/%s", local.github_owner, each.value)
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
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge

  auto_init            = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true
  archive_on_destroy   = true

  dynamic "template" {
    for_each = var.template == null ? [] : [var.template]

    content {
      owner      = local.github_owner
      repository = template.value
    }
  }

  # TODO: Allow configuration override
  dynamic "security_and_analysis" {
    # We can only enable this if the repository's visibility is public
    for_each = var.visibility == "public" ? ["enabled"] : []

    content {
      secret_scanning {
        status = "enabled"
      }

      secret_scanning_push_protection {
        # We can only enable this if the repository's visibility is public
        # BUG: setting it to "enabled" doesn't seem to work, each plan tries to set it from "disabled" to "enabled" again.
        # Keep it disabled for now
        status = "disabled"
      }
    }
  }
}

resource "github_actions_variable" "map" {
  for_each = var.variables

  repository    = github_repository.repository.name
  variable_name = each.key
  value         = each.value
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
  for_each = setsubtract(keys(local.protected_branches), [local.start_branch])

  repository    = github_repository.repository.name
  branch        = each.key
  source_branch = local.start_branch
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = var.default_branch

  depends_on = [github_branch.branch]
}

resource "github_branch_protection" "protection" {
  for_each = { for key, value in local.protected_branches : key => merge(var.default_branch_protection_settings, value) if var.visibility == "public" }

  repository_id                   = github_repository.repository.name
  pattern                         = try(each.value.pattern, null) == null ? each.key : each.value.pattern
  enforce_admins                  = each.value.enforce_admins
  allows_deletions                = each.value.allows_deletions
  allows_force_pushes             = each.value.allows_force_pushes
  require_conversation_resolution = each.value.require_conversation_resolution
  require_signed_commits          = each.value.require_signed_commits

  push_restrictions    = each.value.push_restrictions
  force_push_bypassers = each.value.force_push_bypassers

  required_status_checks {
    strict = each.value.required_status_checks.strict
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
    dismissal_restrictions          = each.value.required_pull_request_reviews.dismissal_restrictions
    restrict_dismissals             = each.value.required_pull_request_reviews.restrict_dismissals
    require_code_owner_reviews      = each.value.required_pull_request_reviews.require_code_owner_reviews
    required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
    pull_request_bypassers          = distinct(concat([var.terraform_app_node_id], each.value.required_pull_request_reviews.pull_request_bypassers))
  }

  depends_on = [
    github_branch.branch,
    github_repository_environment.env,
    github_repository_file.files
  ]
}

resource "github_branch_protection" "all" {
  for_each               = var.visibility == "public" ? toset(["*", "**/**"]) : []
  repository_id          = github_repository.repository.name
  pattern                = each.key
  enforce_admins         = true
  allows_deletions       = true
  require_signed_commits = true
  allows_force_pushes    = true

  depends_on = [
    github_branch.branch,
    github_repository_environment.env,
    github_repository_file.files
  ]
}

########################################################
#
# Provision Terraform initial repository file
#
########################################################
resource "github_repository_file" "init" {
  repository = github_repository.repository.name
  branch     = github_branch_default.default.branch

  file                = ".terraform_init"
  content             = format("DO NOT REMOVE\nThis repository is managed by Terraform and contains files that will be overwritten when changed\nThis file is part of the management of repository %s\n", github_repository.repository.name)
  overwrite_on_create = "true"

  commit_message = "ci: terraform provisioned file changes\n\n[skip ci]"
}

########################################################
#
# Provision Terraform managed repository files
#
########################################################
resource "github_repository_file" "files" {
  for_each = var.repository_files

  repository = github_repository.repository.name
  branch     = github_branch_default.default.branch

  file                = each.key
  content             = each.value.content
  overwrite_on_create = each.value.overwrite_on_create

  commit_message = "fixup! ci: terraform provisioned file changes\n\n[skip ci]"
  depends_on     = [github_repository_file.init]
}

########################################################
#
# Create webhooks
#
########################################################
resource "github_repository_webhook" "map" {
  for_each = var.webhooks

  repository = github_repository.repository.name
  active     = each.value.active
  events     = each.value.events

  configuration {
    url          = each.value.configuration.url
    content_type = each.value.configuration.content_type
    insecure_ssl = false
  }
}
