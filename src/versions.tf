terraform {
  required_version = ">= 1.3"
  required_providers {
    github = {
      source = "integrations/github"
      # https://github.com/integrations/terraform-provider-github/issues/1373
      version = "!= 5.9.0"
    }
  }
}
