#################################################
#
# Temporary file to tell Terraform some resources
# have been renamed in the state.
# Can be removed after apply
#
#################################################
moved {
  from = module.repository_tf["gcp-network"].data.github_team.owner
  to   = module.repository_tf_gcp["network"].data.github_team.owner
}
moved {
  from = module.repository_tf["gcp-network"].github_branch_default.default
  to   = module.repository_tf_gcp["network"].github_branch_default.default
}
moved {
  from = module.repository_tf["gcp-network"].github_branch_protection.all["*"]
  to   = module.repository_tf_gcp["network"].github_branch_protection.all["*"]
}
moved {
  from = module.repository_tf["gcp-network"].github_branch_protection.all["**/**"]
  to   = module.repository_tf_gcp["network"].github_branch_protection.all["**/**"]
}
moved {
  from = module.repository_tf["gcp-network"].github_branch_protection.protection["main"]
  to   = module.repository_tf_gcp["network"].github_branch_protection.protection["main"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository.repository
  to   = module.repository_tf_gcp["network"].github_repository.repository
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".commitlintrc.yml"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".commitlintrc.yml"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".cspell.config.yaml"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".cspell.config.yaml"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".editorconfig"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".editorconfig"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".env.base"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".env.base"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".github/CODEOWNERS"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".github/workflows/terraform.yml"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".github/workflows/terraform.yml"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".gitignore"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".gitignore"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/base.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/base.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/commitlint.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/commitlint.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/cspell.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/cspell.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/editorconfig.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/editorconfig.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/env.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/env.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/markdown.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/markdown.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files[".make/terraform.mk"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files[".make/terraform.mk"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files["CONTRIBUTING.md"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files["CONTRIBUTING.md"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.files["Makefile"]
  to   = module.repository_tf_gcp["network"].github_repository_file.files["Makefile"]
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_file.init
  to   = module.repository_tf_gcp["network"].github_repository_file.init
}
moved {
  from = module.repository_tf["gcp-network"].github_repository_webhook.map["discord"]
  to   = module.repository_tf_gcp["network"].github_repository_webhook.map["discord"]
}
moved {
  from = module.repository_tf["gcp-network"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf_gcp["network"].github_team_repository.maintainer["devops"]
}
moved {
  from = module.repository_tf["gcp-network"].github_team_repository.maintainer["services"]
  to   = module.repository_tf_gcp["network"].github_team_repository.maintainer["services"]
}


moved {
  from = module.repository_tf["gcp-organization"].data.github_team.owner
  to   = module.repository_tf_gcp["organization"].data.github_team.owner
}
moved {
  from = module.repository_tf["gcp-organization"].github_branch_default.default
  to   = module.repository_tf_gcp["organization"].github_branch_default.default
}
moved {
  from = module.repository_tf["gcp-organization"].github_branch_protection.all["*"]
  to   = module.repository_tf_gcp["organization"].github_branch_protection.all["*"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_branch_protection.all["**/**"]
  to   = module.repository_tf_gcp["organization"].github_branch_protection.all["**/**"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_branch_protection.protection["main"]
  to   = module.repository_tf_gcp["organization"].github_branch_protection.protection["main"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository.repository
  to   = module.repository_tf_gcp["organization"].github_repository.repository
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".commitlintrc.yml"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".commitlintrc.yml"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".cspell.config.yaml"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".cspell.config.yaml"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".editorconfig"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".editorconfig"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".env.base"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".env.base"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".github/CODEOWNERS"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".github/workflows/terraform.yml"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".github/workflows/terraform.yml"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".gitignore"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".gitignore"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/base.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/base.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/commitlint.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/commitlint.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/cspell.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/cspell.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/editorconfig.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/editorconfig.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/env.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/env.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/markdown.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/markdown.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files[".make/terraform.mk"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files[".make/terraform.mk"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files["CONTRIBUTING.md"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files["CONTRIBUTING.md"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.files["Makefile"]
  to   = module.repository_tf_gcp["organization"].github_repository_file.files["Makefile"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_file.init
  to   = module.repository_tf_gcp["organization"].github_repository_file.init
}
moved {
  from = module.repository_tf["gcp-organization"].github_repository_webhook.map["discord"]
  to   = module.repository_tf_gcp["organization"].github_repository_webhook.map["discord"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf_gcp["organization"].github_team_repository.maintainer["devops"]
}
moved {
  from = module.repository_tf["gcp-organization"].github_team_repository.maintainer["services"]
  to   = module.repository_tf_gcp["organization"].github_team_repository.maintainer["services"]
}



moved {
  from = module.repository_tf["gcp-projects"].data.github_team.owner
  to   = module.repository_tf_gcp["projects"].data.github_team.owner
}
moved {
  from = module.repository_tf["gcp-projects"].github_branch_default.default
  to   = module.repository_tf_gcp["projects"].github_branch_default.default
}
moved {
  from = module.repository_tf["gcp-projects"].github_branch_protection.all["*"]
  to   = module.repository_tf_gcp["projects"].github_branch_protection.all["*"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_branch_protection.all["**/**"]
  to   = module.repository_tf_gcp["projects"].github_branch_protection.all["**/**"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_branch_protection.protection["main"]
  to   = module.repository_tf_gcp["projects"].github_branch_protection.protection["main"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository.repository
  to   = module.repository_tf_gcp["projects"].github_repository.repository
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".commitlintrc.yml"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".commitlintrc.yml"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".cspell.config.yaml"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".cspell.config.yaml"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".editorconfig"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".editorconfig"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".env.base"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".env.base"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".github/CODEOWNERS"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".github/workflows/terraform.yml"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".github/workflows/terraform.yml"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".gitignore"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".gitignore"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/base.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/base.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/commitlint.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/commitlint.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/cspell.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/cspell.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/editorconfig.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/editorconfig.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/env.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/env.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/markdown.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/markdown.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files[".make/terraform.mk"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files[".make/terraform.mk"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files["CONTRIBUTING.md"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files["CONTRIBUTING.md"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.files["Makefile"]
  to   = module.repository_tf_gcp["projects"].github_repository_file.files["Makefile"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_file.init
  to   = module.repository_tf_gcp["projects"].github_repository_file.init
}
moved {
  from = module.repository_tf["gcp-projects"].github_repository_webhook.map["discord"]
  to   = module.repository_tf_gcp["projects"].github_repository_webhook.map["discord"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf_gcp["projects"].github_team_repository.maintainer["devops"]
}
moved {
  from = module.repository_tf["gcp-projects"].github_team_repository.maintainer["services"]
  to   = module.repository_tf_gcp["projects"].github_team_repository.maintainer["services"]
}



moved {
  from = module.repository_tf["gcp-services-app"].data.github_team.owner
  to   = module.repository_tf_gcp["services-app"].data.github_team.owner
}
moved {
  from = module.repository_tf["gcp-services-app"].github_branch_default.default
  to   = module.repository_tf_gcp["services-app"].github_branch_default.default
}
moved {
  from = module.repository_tf["gcp-services-app"].github_branch_protection.all["*"]
  to   = module.repository_tf_gcp["services-app"].github_branch_protection.all["*"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_branch_protection.all["**/**"]
  to   = module.repository_tf_gcp["services-app"].github_branch_protection.all["**/**"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_branch_protection.protection["main"]
  to   = module.repository_tf_gcp["services-app"].github_branch_protection.protection["main"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository.repository
  to   = module.repository_tf_gcp["services-app"].github_repository.repository
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".commitlintrc.yml"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".commitlintrc.yml"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".cspell.config.yaml"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".cspell.config.yaml"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".editorconfig"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".editorconfig"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".env.base"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".env.base"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".github/CODEOWNERS"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".github/workflows/sanity_checks.yml"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".github/workflows/terraform.yml"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".github/workflows/terraform.yml"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".gitignore"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".gitignore"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/base.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/base.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/commitlint.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/commitlint.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/cspell.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/cspell.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/editorconfig.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/editorconfig.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/env.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/env.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/markdown.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/markdown.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files[".make/terraform.mk"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files[".make/terraform.mk"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files["CONTRIBUTING.md"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files["CONTRIBUTING.md"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.files["Makefile"]
  to   = module.repository_tf_gcp["services-app"].github_repository_file.files["Makefile"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_file.init
  to   = module.repository_tf_gcp["services-app"].github_repository_file.init
}
moved {
  from = module.repository_tf["gcp-services-app"].github_repository_webhook.map["discord"]
  to   = module.repository_tf_gcp["services-app"].github_repository_webhook.map["discord"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_team_repository.maintainer["devops"]
  to   = module.repository_tf_gcp["services-app"].github_team_repository.maintainer["devops"]
}
moved {
  from = module.repository_tf["gcp-services-app"].github_team_repository.maintainer["services"]
  to   = module.repository_tf_gcp["services-app"].github_team_repository.maintainer["services"]
}
