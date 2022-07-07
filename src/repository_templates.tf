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

########################################################
#
# Provision sdd file
#
########################################################
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
