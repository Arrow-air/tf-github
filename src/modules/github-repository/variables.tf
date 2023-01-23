variable "terraform_app_node_id" {
  description = "Node ID of terraform app, This node ID is found by querying the GitHub API `gh api -H \"Accept: application/vnd.github+json\" /apps/<your app slug>`"
  type        = string
}

variable "github_owner" {
  description = "The namespace to be used to create repositories"
  type        = string
  default     = "Arrow-air"
}

variable "name" {
  description = "The repository name"
  type        = string
}

variable "description" {
  description = "The repository description"
  type        = string
}

variable "visibility" {
  description = "The repository visibility. Can be public or private. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be internal."
  type        = string
  default     = "public"
}

variable "is_template" {
  description = "Set to true to tell GitHub that this is a template repository."
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branch after a pull request is merged."
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Set to true to enable squash merges on the repository"
  type        = bool
  default     = false
}

variable "allow_rebase_merge" {
  description = "Set to true to enable rebase merges on the repository"
  type        = bool
  default     = false
}

variable "template" {
  description = "Optional template to use for provisioning of the repository."
  type        = string
  default     = null
}

variable "owner_team" {
  description = "The GitHub team to be used. Will be added to admins for private repositories and added in the CODEOWNERS file for public repositories."
  type        = string
}

variable "collaborators" {
  description = "Repository collaborators and permissions."
  type = object({
    admins      = optional(set(string), [])
    maintainers = optional(set(string), [])
    pushers     = optional(set(string), [])
    pullers     = optional(set(string), [])
  })

  default = {}
}

variable "default_branch" {
  description = "Repository default branch"
  type        = string
  default     = "main"
}

variable "protected_branches" {
  description = "Long lived (protected) branches to be created"

  type = map(object({
    pattern                         = optional(string)
    enforce_admins                  = optional(bool, false)
    allows_deletions                = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    require_conversation_resolution = optional(bool, true)
    require_signed_commits          = optional(bool, true)

    push_restrictions = optional(list(string), [])

    required_status_checks = optional(
      object({
        strict = optional(bool, true)
      }),
      { strict = true }
    )

    required_pull_request_reviews = optional(
      object({
        dismiss_stale_reviews           = optional(bool, true)
        restrict_dismissals             = optional(bool, true)
        require_code_owner_reviews      = optional(bool, true)
        required_approving_review_count = optional(number, 1)
        dismissal_restrictions          = optional(list(string), [])
        pull_request_bypassers          = optional(list(string), [])
      }),
      {
        dismiss_stale_reviews           = true
        restrict_dismissals             = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
        dismissal_restrictions          = []
        pull_request_bypassers          = []
      }
    )
  }))

  default = {
    "main" = {}
  }
}

variable "environments" {
  description = "Repository environments to be created."
  type = map(object({
    reviewers = optional(map(
      object({
        team = list(string)
      })
    ), {})
    deployment_branch_policy = optional(object({
      protected_branches     = optional(bool, true)
      custom_branch_policies = optional(bool, true)
    }))
  }))

  default = {}
}

variable "default_branch_protection_settings" {
  description = "Settings to use for protected branches created"

  type = object({
    enforce_admins                  = optional(bool, false)
    allows_deletions                = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    require_conversation_resolution = optional(bool, true)
    require_signed_commits          = optional(bool, true)
    push_restrictions               = optional(list(string), [])

    required_status_checks = optional(
      object({
        strict = optional(bool, true)
      }),
      { strict = true }
    )

    required_pull_request_reviews = optional(
      object({
        dismiss_stale_reviews           = optional(bool, true)
        restrict_dismissals             = optional(bool, true)
        require_code_owner_reviews      = optional(bool, true)
        required_approving_review_count = optional(number, 1)
        dismissal_restrictions          = optional(list(string), [])
        pull_request_bypassers          = optional(list(string), [])
      }),
      {
        dismiss_stale_reviews           = true
        restrict_dismissals             = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
        dismissal_restrictions          = []
        pull_request_bypassers          = []
      }
    )
  })

  default = {
    enforce_admins                  = false
    allows_deletions                = false
    allows_force_pushes             = false
    require_conversation_resolution = true
    require_signed_commits          = true
    push_restrictions               = []
    required_status_checks          = { strict = true }

    required_pull_request_reviews = {
      dismiss_stale_reviews           = true
      restrict_dismissals             = true
      require_code_owner_reviews      = true
      required_approving_review_count = 1
      dismissal_restrictions          = []
      pull_request_bypassers          = []
    }
  }
}

variable "enable_discord_events" {
  description = "When enabled, repository events will be announced to discord"
  type        = bool
  default     = false
}

variable "webhooks" {
  description = "Map of webhooks to create for the repository. Please note that urls contain secrets, they should be taken from a secret value and not added into the repository as plain text"
  type = map(object({
    active = optional(bool, true)
    events = list(string)

    configuration = object({
      url          = string
      secret       = optional(string)
      content_type = optional(string, "json")
    })
  }))
  default = {}
}

variable "repository_files" {
  description = "List of files that should be provisioned in the repository through Terraform"
  type = map(object({
    content             = string
    overwrite_on_create = optional(bool, true)
  }))
  default = {}
}
