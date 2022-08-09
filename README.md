# tf-github

Terraform code to manage GitHub repositories.
Resources currently managed by this repository are:
 * GitHub repositories
 * Repository branch protections
 * Repository permissions
 * Generic files for multiple repositories

## CICD

To deploy changes from this repository, we've installed a Terraform app to provide authentication for the Terraform actions performed on the GitHub resources.

Multiple secrets have been created in the repository settings itself, which are needed to run the GitHub Actions:
| Secret                                  | Description                                                                                                            |
| --------------------------------------- | -----------------------------------------------------------------------------------------------------------------------|
| TF_CLOUD_TOKEN                          | Used to authenticate with Terraform Cloud for state management                                                         |
| TF_GITHUB_APP_PEM_FILE                  | Needed to allow managing of GitHub resources through the Terraform app installed on the Arrow-air Github Organization. |
| TF_VAR_DISCORD_SERVICES_INTEGRATION_URL | Variable needed by Terraform containing the `services` team discord integration URL.                                   |

Each PR will trigger a workflow to output the Terraform plan. This plan should always be checked before merging to `main`.
As soon as the PR is merged to `main`, a workflow will run to deploy the changes with Terraform.

# Repository management

All repositories are created through the internal `github-repository` module, allowing for easy management of branch protections, files and webhooks.
Repositories that require similar settings, are grouped into seperate files. The configurations provided by these `repositories_*.tf` files also enforce naming conventions.

The following repository types are currently pre-defined:
 * `tf`  -- Repositories containing Terraform code
 * `lib-<name>-rust` -- Repositories for the Arrow libraries written in Rust
 * `svc-<name>-rust` -- Repositories for the Arrow services written in Rust
 * `lib-template-<lang>` -- Repository templates for Arrow libraries
 * `svc-template-<lang>` -- Repository templates for Arrow services

## Adding a new repository

:construction: Coming Soon :construction:
