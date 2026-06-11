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
Repositories that require similar settings, are grouped into separate files. The configurations provided by these `repositories_*.tf` files also enforce naming conventions.

The following repository groups are currently pre-defined:

| File                         | Naming convention                                  | Description                                                  |
| ---------------------------- | -------------------------------------------------- | ------------------------------------------------------------ |
| `main.tf`                    | no prefix                                          | General repositories (website, DAO governance, services)     |
| `repositories_terraform.tf`  | `tf-<name>`, `tf-gcp-<name>`, `terraform-<name>`   | Terraform configuration and shared module repositories       |
| `repositories_pod.tf`        | `project-<name>`                                   | Arrow pod project repositories                               |
| `repositories_embedded.tf`   | no prefix                                          | STM32 embedded projects                                      |
| `repositories_templates.tf`  | `embedded-template-<name>`, `pod-template-<name>`  | Template repositories used to provision the groups above     |

## Managed files

The module provisions two kinds of files into repositories:
 * `repository_files` -- fully managed by Terraform. Local changes are overwritten on the next apply. These files carry a `DO NOT EDIT` header.
 * `seeded_repository_files` -- created with initial content when the repository is first provisioned, but owned by the repository afterwards. Terraform will not touch them again (e.g. `.cspell.config.yaml`).

## Adding a new repository

1. Make sure the owning team exists. Teams are managed in the (private) `tf-onboarding` repository -- if the team is new, merge that change first, otherwise the plan here fails on the team lookup.
2. Add the repository to the map in the matching `repositories_*.tf` file (or `local.repos` in `main.tf` for general repositories), providing at minimum a `description`, `visibility` and `owner_team`.
3. Open a PR. The workflow posts the Terraform plan as a PR comment -- always review it before merging.
4. Merge to `main`. The workflow applies the change automatically.

Please note that branch protections are only applied to public repositories; they are not supported for private repositories on the current GitHub plan.
