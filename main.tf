terraform {
  required_providers {
    artifactory = {
      source  = "registry.terraform.io/jfrog/artifactory"
      version = "~> 2.2.5"
    }
  }
}

# Configured via ENV
provider "artifactory" {}

module "core" {
  source = "./modules/core"
}

//resource "artifactory_local_repository" "bug-npm-local" {
//  key          = "bug-npm-local"
//  package_type = "npm"
//}