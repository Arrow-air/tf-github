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

  # generate list of variables to be created per environment
  environment_variables = merge([
    for environment, settings in var.environments : {
      for variable, value in settings.variables : format("%s|%s", environment, variable) => {
        environment   = environment
        variable_name = variable
        value         = value
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

resource "github_actions_environment_variable" "environment_variable" {
  for_each = local.environment_variables

  repository    = github_repository.repository.name
  environment   = github_repository_environment.env[each.value.environment].environment
  variable_name = each.value.variable_name
  value         = each.value.value
}
