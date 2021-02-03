resource "artifactory_local_repository" "bug-npm-local" {
  key          = "bug-npm-local"
  package_type = "npm"
}