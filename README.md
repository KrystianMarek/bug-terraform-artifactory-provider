# This is to provide context for two issues found in [artifactory terraform provider v2.2.5](https://registry.terraform.io/providers/jfrog/artifactory/latest)

## Test environment
The following was tested on macOS 10.15.7, with terraform v0.14.5

## terraform init fails
`terraform init` fails when module is called from within the main.tf. Consider branch master and terraform_init of this repo.  
The error message is:  
```bash
❯ terraform init
Initializing modules...
- core in modules/core

Initializing the backend...

Initializing provider plugins...
- Finding jfrog/artifactory versions matching "~> 2.2.5"...
- Finding latest version of hashicorp/artifactory...
- Installing jfrog/artifactory v2.2.5...
- Installed jfrog/artifactory v2.2.5 (signed by a HashiCorp partner, key ID 6B219DCCD7639232)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/plugins/signing.html

Error: Failed to query available provider packages

Could not retrieve the list of available versions for provider
hashicorp/artifactory: provider registry registry.terraform.io does not have a
provider named registry.terraform.io/hashicorp/artifactory

If you have just upgraded directly from Terraform v0.12 to Terraform v0.14
then please upgrade to Terraform v0.13 first and follow the upgrade guide for
that release, which might help you address this problem.
```