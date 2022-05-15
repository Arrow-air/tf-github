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

variable "owner_team" {
  description = "The GitHub team to be used. Will be added to admins for private repositories and added in the CODEOWNERS file for public repositories."
  type        = string
}

variable "collaborators" {
  description = "Repository collaborators and permissions."
  type = object({
    admins      = optional(list(string))
    maintainers = optional(list(string))
  })

  default = null
}

variable "default_branch" {
  description = "Repository default branch"
  type        = string
  default     = "staging"
}

variable "other_branches" {
  description = "Repository additional long lived branches"
  type        = list(string)
  default     = ["main"]
}

variable "environments" {
  description = "Repository environments to be created."
  type = map(object({
    reviewers = optional(map(
      object({
        team = list(string)
      })
    ))
    deployment_branch_policy = optional(object({
      protected_branches     = optional(bool)
      custom_branch_policies = optional(bool)
    }))
  }))

  default = null
}

variable "enable_discord_events" {
  description = "When enabled, repository events will be announced to discord"
  type        = bool
  default     = false
}
