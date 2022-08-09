# Terraform Azure Template

This project provides a baseline based on the [Provision an AKS Cluster](https://learn.hashicorp.com/terraform/kubernetes/provision-aks-cluster) learn guide, containing Terraform configuration files to provision an AKS cluster on Azure.
[Terraform](https://www.terraform.io/) enables the definition, preview, and deployment of cloud infrastructure.

## Table of Contents

- [Project structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Available make commands](#available-make-commands)
- [Linting and formatting](#linting-and-formatting)
- [Running unit tests](#running-unit-tests)
- [Security scanning](#security-scanning)
- [Estimating infrastructure costs](#estimating-infrastructure-costs)
- [Debugging](#debugging)
- [Deploying](#deploying)
- [Reference documentation](#reference-documentation)

## Project structure

When working in a large team with many developers that are responsible for the same codebase, having a common understanding of how the project should be structured is vital.
Based on best practices from the community, [Terraform Module Structure](https://www.terraform.io/language/modules/develop/structure), other github projects and developer experience, your project should look like this:

```bash
.
├── modules
│   └── kubernetes
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── tests
│   └── kubernetes
│       └── main.rego
├── .editorconfig
├── .gitignore
├── .terraform.lock.hcl
├── .tflint.hcl
├── main.tf
├── Makefile
├── README.md
└── versions.tf
```

Modules in Terraform are parametrized code containers enclosing multiple resource declarations.
The unit tests are in the `tests` folder.

## Prerequisites

Follow the next instructions to configure and run the project on your local machine:

- Install, at least, [Terraform](https://www.terraform.io/) and [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).
- Provide the following environment variables to allow the access to Azure subscription:
  - `ARM_CLIENT_ID=<SERVICE_PRINCIPAL_ID>`
  - `ARM_CLIENT_SECRET=<SERVICE_PRINCIPAL_SECRET>`
  - `ARM_SUBSCRIPTION_ID=<SUBSCRIPTION_ID>`
  - `ARM_TENANT_ID=<TENANT_ID>`
- Prepare your working directory for other Terraform commands with `terraform init` command.
- Install (optional) `Conftest`, `Infracost`, `TFLint` and `tfsec` to enforce best practices.

## Available make commands

The commands in [Makefile](Makefile) file were built with simplicity in mind to automate as much repetitive tasks as possible and help developers focus on what really matters.

The next commands should be executed in a console inside the root directory:

- `make install` - Installs all Terraform dependencies.
- `make check` - Runs all checks.
- `make lint` - Runs several static code analysis.
- `make format` - Applies code formatting steps to source code in-place.
- `make test` - Runs the unit tests.
- `make scan` - Runs the security scanning analysis.
- `make cost` - Estimates the infrastructure costs.
- `make validate` - Checks whether the configuration is valid.
- `make plan` - Shows changes required by the current configuration.
- `make apply` - Creates or updates the infrastructure.
- `make destroy` - Destroys previously-created infrastructure.
- `make clean` - Deletes the temporary directories.

For more details, read the [make](https://www.gnu.org/software/make/manual/make.html) documentation.
Alternatively, you can use the commands defined in the [Makefile](Makefile).

## Linting and formatting

Linters are also excellent tools for finding certain classes of bugs, such as those related to variable scope.
[TFLint](https://github.com/terraform-linters/tflint) is a linter that checks for possible errors, best practices, etc in your Terraform code.

To enforce all best practices, you can use the next command:

```bash
make lint
```

Many problems can be automatically fixed with `make format`.

Depending on your editor, you may want to add an editor extension to lint your files while you type or on-save.
This project includes some recommendations for *Visual Studio Code*.

## Running unit tests

Unit tests are responsible for testing of individual things by supplying input and making sure the output is as expected.
[Conftest](https://www.conftest.dev/) is a utility to help you write tests against structured configuration data.
*Conftest* relies on the *Rego* language from [Open Policy Agent](https://www.openpolicyagent.org/) for writing tests.

To run the unit tests, you can use the next command:

```bash
make test
```

*Conftest* looks for `deny`, `violation`, and `warn` rules.
Rules can optionally be suffixed with an underscore and an identifier, for example `deny_myrule`.
For more details, you can read the [Policy Language](https://www.openpolicyagent.org/docs/latest/policy-language/) documentation.

By default, *Conftest* looks for these rules in the `main` namespace, but this can be overriden with the `--namespace` flag.
To look in all namespaces, use the `--all-namespaces` flag.

Beyond that, *Conftest* supports multiple output types.
For more details, see the documentation about [--output flag](https://www.conftest.dev/options/#-output).

## Security scanning

Security scanners are valuable tools that search for and report on what known security issues are present in an organization’s infrastructure.
[tfsec](https://aquasecurity.github.io/tfsec/) uses static analysis of your Terraform templates to spot potential security issues.
*tfsec* ensures that security issues can be detected before your infrastructure changes take effect.

To scan for security issues, you can use the next command:

```bash
make scan
```

*tfsec* can be run with no arguments and will act on the current folder.
For a richer experience, there are many additional command line arguments that you can make use of.

## Estimating infrastructure costs

Estimating infrastructure costs is a vital aspect of any project.
Azure provides a [calculator](https://azure.microsoft.com/pricing/calculator/) for estimating infrastructure costs.
Alternatively, you can use [Infracost](https://www.infracost.io/) to estimate the cloud cost for Terraform.
You need to register for a free API key, which is used by the CLI to retrieve prices from our Cloud Pricing API, and set the `INFRACOST_API_KEY` environment variable.

To show a breakdown of costs, you can use the next command:

```bash
make cost
```

Internally *Infracost* parses the Terraform HCL code directly thus no cloud credentials or Terraform secrets are required.
[Cost policies](https://www.infracost.io/docs/features/cost_policies/) enable DevOps and FinOps teams to help engineers to take action around cloud costs.

## Debugging

Terraform has detailed logs which can be enabled by setting the `TF_LOG` environment variable to any value.
This will cause detailed logs to appear on stderr.

You can set `TF_LOG` to one of the log levels (in order of decreasing verbosity) `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR` to change the verbosity of the logs.

To persist logged output you can set `TF_LOG_PATH` in order to force the log to always be appended to a specific file when logging is enabled.
Note that even when `TF_LOG_PATH` is set, `TF_LOG` must be set in order for any logging to be enabled.

## Deploying

When running Terraform in automation, the focus is usually on the core plan/apply cycle.
The `plan` for produces a plan to change the resources to match the current configuration and the `apply` to implement the described changes.

To execute the actions proposed in a Terraform plan, you can use the next command:

```bash
make apply
```

Terraform automatically creates a new execution plan as if you had run `plan`, prompts you to approve that plan, and takes the indicated actions.

By default, Terraform stores state locally in a file named `terraform.tfstate`.
When running in an orchestration tool, it can be difficult or impossible to ensure that the `plan` and `apply` subcommands are run on the same machine, in the same directory, with all of the same files present.
With [remote state](https://www.terraform.io/language/state/remote), Terraform writes the state data to a remote data store, which can then be shared between all members of a team.

If you want to destroy your infrastructure use `make destroy` command.
This command is the inverse of `make apply` in that it terminates all the resources specified in your Terraform state.

## Reference documentation

For further reference, please consider the following articles:

- [Terraform CLI Features](https://www.terraform.io/cli/commands)
- [How To Structure a Terraform Project](https://www.digitalocean.com/community/tutorials/how-to-structure-a-terraform-project)
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/)
- [Azure Terraform QuickStart Templates](https://github.com/Azure/terraform/tree/master/quickstart)
- [Provision an AKS Cluster](https://learn.hashicorp.com/tutorials/terraform/aks?in=terraform/kubernetes)
- [How to use TFLint](https://dhaneshmadavil.wordpress.com/2021/10/29/how-to-use-tflint-to-check-errors-in-your-terraform-code/)
- [Testing HashiCorp Terraform](https://www.hashicorp.com/blog/testing-hashicorp-terraform)
- [Using tfsec to Scan Your Terraform Code](https://www.hashicorp.com/resources/using-tfsec-to-scan-your-terraform-code)
- [Debugging Terraform](https://www.terraform.io/internals/debugging)
- [Store Terraform state in Azure Storage](https://docs.microsoft.com/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

To get more help on the Terraform CLI use `terraform -help` or go check out the [Terraform CLI Features](https://www.terraform.io/cli/commands) page.
