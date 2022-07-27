moved {
  from = module.repository["tf-github"].data.github_team.owner
  to   = module.tf_repository["github"].data.github_team.owner
}

moved {
  from = module.repository["tf-github"].github_branch_default.default
  to   = module.tf_repository["github"].github_branch_default.default
}

moved {
  from = module.repository["tf-github"].github_repository.repository
  to   = module.tf_repository["github"].github_repository.repository
}

moved {
  from = module.repository["tf-github"].github_repository_file.CODEOWNERS
  to   = module.tf_repository["github"].github_repository_file.CODEOWNERS
}

moved {
  from = module.repository["tf-github"].github_team_repository.maintainer["devops"]
  to   = module.tf_repository["github"].github_team_repository.maintainer["devops"]
}

moved {
  from = module.repository["tf-onboarding"].data.github_team.owner
  to   = module.tf_repository["onboarding"].data.github_team.owner
}

moved {
  from = module.repository["tf-onboarding"].github_branch_default.default
  to   = module.tf_repository["onboarding"].github_branch_default.default
}

moved {
  from = module.repository["tf-onboarding"].github_repository.repository
  to   = module.tf_repository["onboarding"].github_repository.repository
}

moved {
  from = module.repository["tf-onboarding"].github_repository_file.CODEOWNERS
  to   = module.tf_repository["onboarding"].github_repository_file.CODEOWNERS
}

moved {
  from = module.repository["tf-onboarding"].github_team_repository.maintainer["devops"]
  to   = module.tf_repository["onboarding"].github_team_repository.maintainer["devops"]
}

moved {
  from = module.repository["svc-storage"].data.github_team.owner
  to   = module.svc_repository["storage"].data.github_team.owner
}

moved {
  from = module.repository["svc-storage"].github_branch_default.default
  to   = module.svc_repository["storage"].github_branch_default.default
}

moved {
  from = module.repository["svc-storage"].github_repository.repository
  to   = module.svc_repository["storage"].github_repository.repository
}

moved {
  from = module.repository["svc-storage"].github_repository_file.CODEOWNERS
  to   = module.svc_repository["storage"].github_repository_file.CODEOWNERS
}

moved {
  from = module.repository["svc-storage"].github_team_repository.maintainer["services"]
  to   = module.svc_repository["storage"].github_team_repository.maintainer["services"]
}

moved {
  from = module.repository["svc-storage"].github_branch_protection.protection["main"]
  to   = module.svc_repository["storage"].github_branch_protection.protection["main"]
}
