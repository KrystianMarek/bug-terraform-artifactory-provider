# This is to provide context for two issues found in [artifactory terraform provider v2.2.5](https://registry.terraform.io/providers/jfrog/artifactory/latest)

## Test environment
The following was tested on macOS 10.15.7, with terraform v0.14.5 installed via brew. It was also tested with the docker version
of terraform via the terraform.sh script.
Terraform is configured with ENV variables, stored in environment.sh - ignored in this repo.
File content:  
```bash
export ARTIFACTORY_URL="https://SOME_SAAS_ARTIFACTORY.jfrog.io/artifactory"
export ARTIFACTORY_API_KEY="secret_key"
```

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

## terraform plan fails
If the issue described above is worked around with all resources placed in the `main.tf` (branch terraform_plan)
`terraform plan` fails with
```bash
❯ terraform plan

Error: Get "https://SOME_SAAS_ARTIFACTORY.jfrog.io/artifactory/api/system/ping": x509: certificate signed by unknown authority

  on main.tf line 11, in provider "artifactory":
  11: provider "artifactory" {}

```
There is no problem with the certificate. This happens when the URL of the artifactory instance is configured via the ENV.
If the URL is provided as a part of provider configuration in the `main.tf` terraform plan works.

Sometimes the `terraform plan` just crashes with
```bash
❯ ./terraform.sh plan

Error: rpc error: code = Canceled desc = context canceled


panic: runtime error: index out of range [-1]
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5:
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: goroutine 15 [running]:
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: github.com/atlassian/terraform-provider-artifactory/pkg/artifactory.providerConfigure(0xc0000c40e0, 0x0, 0x0, 0xc0000c40e0, 0x0)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	github.com/atlassian/terraform-provider-artifactory/pkg/artifactory/provider.go:108 +0xc3e
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: github.com/hashicorp/terraform/helper/schema.(*Provider).Configure(0xc0000af080, 0xc0006b0540, 0x1190940, 0xc0006b04b0)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	github.com/hashicorp/terraform@v0.12.29/helper/schema/provider.go:270 +0xd2
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: github.com/hashicorp/terraform/helper/plugin.(*GRPCProviderServer).Configure(0xc00000e1b0, 0x167db80, 0xc0006b0120, 0xc00063a180, 0xc00000e1b0, 0xc0006b0120, 0xc000697b78)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	github.com/hashicorp/terraform@v0.12.29/helper/plugin/grpc_provider.go:487 +0x2e6
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: github.com/hashicorp/terraform/internal/tfplugin5._Provider_Configure_Handler(0x12f08e0, 0xc00000e1b0, 0x167db80, 0xc0006b0120, 0xc0000789c0, 0x0, 0x167db80, 0xc0006b0120, 0xc00063e040, 0x3d)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	github.com/hashicorp/terraform@v0.12.29/internal/tfplugin5/tfplugin5.pb.go:3135 +0x217
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: google.golang.org/grpc.(*Server).processUnaryRPC(0xc000001b00, 0x168b120, 0xc000642a80, 0xc0001a0a00, 0xc0005a1500, 0x1f6ca98, 0x0, 0x0, 0x0)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	google.golang.org/grpc@v1.27.1/server.go:1024 +0x501
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: google.golang.org/grpc.(*Server).handleStream(0xc000001b00, 0x168b120, 0xc000642a80, 0xc0001a0a00, 0x0)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	google.golang.org/grpc@v1.27.1/server.go:1313 +0xd3d
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: google.golang.org/grpc.(*Server).serveStreams.func1.1(0xc0000aa1c0, 0xc000001b00, 0x168b120, 0xc000642a80, 0xc0001a0a00)
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	google.golang.org/grpc@v1.27.1/server.go:722 +0xa1
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: created by google.golang.org/grpc.(*Server).serveStreams.func1
2021-02-04T10:23:45.471Z [DEBUG] plugin.terraform-provider-artifactory_v2.2.5: 	google.golang.org/grpc@v1.27.1/server.go:720 +0xa1
2021-02-04T10:23:45.473Z [DEBUG] plugin: plugin process exited: path=.terraform/providers/registry.terraform.io/jfrog/artifactory/2.2.5/linux_amd64/terraform-provider-artifactory_v2.2.5 pid=51 error="exit status 2"
2021-02-04T10:23:45.473Z [WARN]  plugin.stdio: received EOF, stopping recv loop: err="rpc error: code = Canceled desc = context canceled"
2021/02/04 10:23:45 [TRACE] vertex "provider[\"registry.terraform.io/jfrog/artifactory\"]": visit complete
2021/02/04 10:23:45 [TRACE] dag/walk: upstream of "artifactory_local_repository.bug-npm-local (expand)" errored, so skipping
2021/02/04 10:23:45 [TRACE] dag/walk: upstream of "meta.count-boundary (EachMode fixup)" errored, so skipping
2021/02/04 10:23:45 [TRACE] dag/walk: upstream of "provider[\"registry.terraform.io/jfrog/artifactory\"] (close)" errored, so skipping
2021/02/04 10:23:45 [TRACE] dag/walk: upstream of "root" errored, so skipping
2021/02/04 10:23:45 [INFO] backend/local: plan operation completed
2021/02/04 10:23:45 [TRACE] statemgr.Filesystem: removing lock metadata file .terraform.tfstate.lock.info
2021/02/04 10:23:45 [TRACE] statemgr.Filesystem: unlocking terraform.tfstate using fcntl flock
2021-02-04T10:23:45.477Z [DEBUG] plugin: plugin exited



!!!!!!!!!!!!!!!!!!!!!!!!!!! TERRAFORM CRASH !!!!!!!!!!!!!!!!!!!!!!!!!!!!

Terraform crashed! This is always indicative of a bug within Terraform.
A crash log has been placed at "crash.log" relative to your current
working directory. It would be immensely helpful if you could please
report the crash with Terraform[1] so that we can fix this.

When reporting bugs, please include your terraform version. That
information is available on the first line of crash.log. You can also
get it by running 'terraform --version' on the command line.

SECURITY WARNING: the "crash.log" file that was created may contain
sensitive information that must be redacted before it is safe to share
on the issue tracker.

[1]: https://github.com/hashicorp/terraform/issues

!!!!!!!!!!!!!!!!!!!!!!!!!!! TERRAFORM CRASH !!!!!!!!!!!!!!!!!!!!!!!!!!!!
```
Consider [crash-terraform.sh_plan.log](crash-terraform.sh_plan.log)