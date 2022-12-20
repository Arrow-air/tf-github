variable "discord_services_integration_url" {
  description = "Secret var to be used for services repositories integration with GitHub. This variable will be provided through a GitHub action secret configured on the Organization and shared with the tf-github repository. See https://www.terraform.io/cli/config/environment-variables on more information how this variable is being passed."
  type        = string
  default     = ""
}

variable "github_auth_pem_file" {
  type    = string
  default = null
}
