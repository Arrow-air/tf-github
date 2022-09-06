#################################################
#
# Temporary file to tell Terraform some resources
# have been renamed in the state.
# Can be removed after apply
#
#################################################
moved {
  from = module.repository["cla-bot"].github_repository_file.CODEOWNERS
  to   = module.repository["cla-bot"].github_repository_file.files[".github/CODEOWNERS"]
}

moved {
  from = module.repository["benchmarks"].github_repository_file.CODEOWNERS
  to   = module.repository["benchmarks"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository["tools"].github_repository_file.CODEOWNERS
  to   = module.repository["tools"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository["website"].github_repository_file.CODEOWNERS
  to   = module.repository["website"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository["se-services"].github_repository_file.CODEOWNERS
  to   = module.repository["se-services"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository["clabot-config"].github_repository_file.CODEOWNERS
  to   = module.repository["clabot-config"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_lib_template["rust"].github_repository_file.CODEOWNERS
  to   = module.repository_lib_template["rust"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_svc_template["rust"].github_repository_file.CODEOWNERS
  to   = module.repository_svc_template["rust"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_svc_template["python"].github_repository_file.CODEOWNERS
  to   = module.repository_svc_template["python"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_svc_template["typescript"].github_repository_file.CODEOWNERS
  to   = module.repository_svc_template["typescript"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_rust_svc["storage"].github_repository_file.CODEOWNERS
  to   = module.repository_rust_svc["storage"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_rust_svc["scheduler"].github_repository_file.CODEOWNERS
  to   = module.repository_rust_svc["scheduler"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_rust_lib["router"].github_repository_file.CODEOWNERS
  to   = module.repository_rust_lib["router"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["github"].github_repository_file.CODEOWNERS
  to   = module.repository_tf["github"].github_repository_file.files[".github/CODEOWNERS"]
}
moved {
  from = module.repository_tf["onboarding"].github_repository_file.CODEOWNERS
  to   = module.repository_tf["onboarding"].github_repository_file.files[".github/CODEOWNERS"]
}
