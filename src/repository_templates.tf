########################################################
#
# Rust template repository
#
########################################################
resource "github_repository" "svc_template_rust" {
  name        = "svc-template-rust"
  description = "Arrow Service repository template for Rust services"
  visibility  = "public"

  auto_init            = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true
  is_template          = true
}
resource "github_team_repository" "svc_template_rust_maintainer" {
  repository = github_repository.svc_template_rust.name
  team_id    = "services"
  permission = "maintain"
}

# Provision sdd file
resource "github_repository_file" "svc_template_rust_sdd" {
  repository          = github_repository.svc_template_rust.name
  branch              = "main"
  file                = "docs/sdd.md"
  content             = file("templates/svc/docs/sdd.md")
  commit_message      = "Provisioned by Terraform"
  commit_email        = "automation@arrowair.com"
  commit_author       = "Arrow automation"
  overwrite_on_create = false
}

########################################################
#
# Python template repository
#
########################################################
resource "github_repository" "svc_template_python" {
  name        = "svc-template-python"
  description = "Arrow Service repository template for Python services"
  visibility  = "public"

  auto_init            = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true
  is_template          = true
}
resource "github_team_repository" "svc_template_python_maintainer" {
  repository = github_repository.svc_template_python.name
  team_id    = "services"
  permission = "maintain"
}

# Provision sdd file
resource "github_repository_file" "svc_template_python_sdd" {
  repository          = github_repository.svc_template_python.name
  branch              = "main"
  file                = "docs/sdd.md"
  content             = file("templates/svc/docs/sdd.md")
  commit_message      = "Provisioned by Terraform"
  commit_email        = "automation@arrowair.com"
  commit_author       = "Arrow automation"
  overwrite_on_create = false
}
