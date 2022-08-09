#################################################
#
# Temporary file to tell Terraform some resources
# have been renamed in the state.
# Can be removed after apply
#
#################################################

moved {
  from = github_repository.lib_template_rust
  to   = module.repository_lib_template["rust"].github_repository.repository
}
moved {
  from = github_repository.svc_template_python
  to   = module.repository_svc_template["python"].github_repository.repository
}
moved {
  from = github_repository.svc_template_rust
  to   = module.repository_svc_template["rust"].github_repository.repository
}
moved {
  from = github_repository.svc_template_typescript
  to   = module.repository_svc_template["typescript"].github_repository.repository
}
moved {
  from = github_team_repository.lib_template_rust_maintainer
  to   = module.repository_lib_template["rust"].github_team_repository.maintainer["services"]
}
moved {
  from = github_team_repository.svc_template_python_maintainer
  to   = module.repository_svc_template["python"].github_team_repository.maintainer["services"]
}
moved {
  from = github_team_repository.svc_template_rust_maintainer
  to   = module.repository_svc_template["rust"].github_team_repository.maintainer["services"]
}
moved {
  from = github_team_repository.svc_template_typescript_maintainer
  to   = module.repository_svc_template["typescript"].github_team_repository.maintainer["services"]
}
moved {
  from = module.tf_repository["github"].github_branch_default.default
  to   = module.repository_tf["github"].github_branch_default.default
}
moved {
  from = module.tf_repository["github"].github_branch_protection.all["tf-github"]
  to   = module.repository_tf["github"].github_branch_protection.all["tf-github"]
}
moved {
  from = module.tf_repository["github"].github_branch_protection.protection["main"]
  to   = module.repository_tf["github"].github_branch_protection.protection["main"]
}
moved {
  from = module.tf_repository["github"].github_repository.repository
  to   = module.repository_tf["github"].github_repository.repository
}
moved {
  from = module.tf_repository["github"].github_repository_file.CODEOWNERS
  to   = module.repository_tf["github"].github_repository_file.CODEOWNERS
}
moved {
  from = module.tf_repository["github"].github_repository_webhook.map["discord"]
  to   = module.repository_tf["github"].github_repository_webhook.map["discord"]
}
moved {
  from = module.tf_repository["github"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf["github"].github_team_repository.maintainer["devops"]
}
moved {
  from = module.tf_repository["github"].github_team_repository.maintainer["services"]
  to   = module.repository_tf["github"].github_team_repository.maintainer["services"]
}
moved {
  from = module.tf_repository["onboarding"].github_branch_default.default
  to   = module.repository_tf["onboarding"].github_branch_default.default
}
moved {
  from = module.tf_repository["onboarding"].github_repository.repository
  to   = module.repository_tf["onboarding"].github_repository.repository
}
moved {
  from = module.tf_repository["onboarding"].github_repository_file.CODEOWNERS
  to   = module.repository_tf["onboarding"].github_repository_file.CODEOWNERS
}
moved {
  from = module.tf_repository["onboarding"].github_repository_webhook.map["discord"]
  to   = module.repository_tf["onboarding"].github_repository_webhook.map["discord"]
}
moved {
  from = module.tf_repository["onboarding"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf["onboarding"].github_team_repository.maintainer["devops"]
}
