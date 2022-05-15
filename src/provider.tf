terraform {
  cloud {
    organization = "Arrow-air"
    workspaces {
      tags = ["github"]
    }
  }
}

provider "github" {
  owner = "Arrow-air"

  app_auth {
    id              = 175408
    installation_id = 23590789
  }
}
