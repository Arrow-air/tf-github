locals {
  # generate list of secrets to be created per environment
  environment_secrets = merge([
    for environment, settings in var.environments : {
      for secret, value in settings.secrets : format("%s|%s", environment, secret) => {
        environment     = environment
        secret_name     = secret
        plaintext_value = value
      }
    }
  ]...)
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

resource "github_actions_environment_secret" "environment_secret" {
  for_each = local.environment_secrets

  repository      = github_repository.repository.name
  environment     = github_repository_environment.env[each.value.environment].environment
  secret_name     = each.value.secret_name
  plaintext_value = each.value.plaintext_value
}
