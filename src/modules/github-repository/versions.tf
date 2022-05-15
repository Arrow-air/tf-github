terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 1.1.5"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
