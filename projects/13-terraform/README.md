# Terraform Docker Infrastructure

## 1. Overview

This project uses Terraform to provision and manage Nginx Docker containers.

It demonstrates Infrastructure as Code (IaC), Terraform workspaces,
variables, outputs, resource iteration with for_each, state management,
and GitHub Actions validation.

Terraform communicates with Docker Engine through the
kreuzwerker/docker provider.

## 2. Architecture

```text
Terraform Configuration
          |
          v
Terraform Docker Provider
          |
          v
Docker Engine
          |
          v
Nginx Containers
```

Terraform defines the desired infrastructure and tracks managed
resources in its state. Docker Engine runs the actual containers.

## 3. Prerequisites

- Linux
- Docker Engine
- Terraform
- Git

Versions used in the development environment:

- Terraform: 1.16.1
- Docker Engine: 29.1.3
- Docker Provider: 3.6.2

## 4. Project Structure

```text
13-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── .terraform.lock.hcl
├── .gitignore
└── README.md
```

### main.tf

Defines the Docker provider, Nginx image, container resources,
for_each iteration, and moved blocks for resource address migration.

### variables.tf

Defines the image_name variable and nginx_instances map.

Each container entry specifies a container name and external port.

### outputs.tf

Exports container names, container IDs, and the image name.

### terraform.tfvars.example

Provides an example configuration for the default environment.

### .terraform.lock.hcl

Locks the selected provider version and provider checksums.

## 5. Terraform Workspaces

The project uses three workspaces:

| Workspace | Variable file | Desired containers |
|---|---|---:|
| default | terraform.tfvars | 3 |
| dev | dev.tfvars | 2 |
| prod | prod.tfvars | 0 |

Workspaces isolate Terraform state. They do not automatically load
custom variable files. Use -var-file to load the correct configuration.

## 6. Default Environment

The default workspace manages three Nginx containers.

| Container | External port | Internal port |
|---|---:|---:|
| terraform-nginx | 8089 | 80 |
| terraform-nginx-2 | 8090 | 80 |
| terraform-nginx-3 | 8091 | 80 |

Initialize Terraform:

```bash
terraform init
```

Preview changes:

```bash
TF_WORKSPACE=default terraform plan -var-file=terraform.tfvars
```

Apply changes after reviewing the plan:

```bash
TF_WORKSPACE=default terraform apply -var-file=terraform.tfvars
```

## 7. Development Environment

The dev workspace manages two Nginx containers.

| Container | External port | Internal port |
|---|---:|---:|
| terraform-dev-nginx | 8189 | 80 |
| terraform-dev-nginx-2 | 8190 | 80 |

Preview changes:

```bash
TF_WORKSPACE=dev terraform plan -var-file=dev.tfvars
```

Apply changes after reviewing the plan:

```bash
TF_WORKSPACE=dev terraform apply -var-file=dev.tfvars
```

## 8. Production Environment

The prod workspace currently manages no Nginx containers.
This is intentional.

Preview the production configuration:

```bash
TF_WORKSPACE=prod terraform plan -var-file=prod.tfvars
```

Review every production plan carefully before applying changes.

## 9. Terraform State

The project currently uses the local Terraform backend.

Workspace state locations:

- default: terraform.tfstate
- dev: terraform.tfstate.d/dev/terraform.tfstate
- prod: terraform.tfstate.d/prod/terraform.tfstate

State files contain infrastructure metadata and must not be committed
to Git.

For production deployments, consider a remote backend with state
locking, access control, and appropriate backup procedures.

## 10. Useful Terraform Commands

Format Terraform files:

```bash
terraform fmt -recursive
```

Check formatting without modifying files:

```bash
terraform fmt -check -recursive
```

Validate configuration:

```bash
terraform validate
```

List workspaces:

```bash
terraform workspace list
```

List resources in each workspace:

```bash
TF_WORKSPACE=default terraform state list
TF_WORKSPACE=dev terraform state list
TF_WORKSPACE=prod terraform state list
```

Generate a default environment plan:

```bash
TF_WORKSPACE=default terraform plan -var-file=terraform.tfvars
```

## 11. GitHub Actions

The repository workflow is:

`.github/workflows/docker-build.yml`

It runs on pushes and pull requests targeting the main branch.

The workflow contains two jobs.

### Docker Build CI

- Checks out the repository.
- Builds the backend Docker image.
- Validates the Docker Compose configuration.

### Terraform CI

- Checks out the repository.
- Installs Terraform 1.16.1.
- Checks Terraform formatting.
- Initializes Terraform with -backend=false.
- Runs terraform validate.

The Terraform CI job validates configuration. It does not apply
infrastructure changes.

## 12. Security and Git

The following files and directories must not be committed:

- Terraform state files
- Local environment variable files
- Terraform plan files
- Local backup files
- .terraform directories

Never commit passwords, API tokens, private keys, or other secrets.

The example variable file may be committed when it contains only
non-sensitive example values.

## 13. Current Project Status

- Docker provider configured.
- Nginx image managed by Terraform.
- Multiple containers managed with for_each.
- Default workspace operational with three containers.
- Dev workspace operational with two containers.
- Prod workspace intentionally empty.
- Terraform state verified.
- Docker containers verified.
- HTTP endpoints tested successfully.
- GitHub Actions Terraform validation configured.

## 14. Future Improvements

1. Improve Terraform CI validation.
2. Build and publish Docker images to a container registry.
3. Introduce reviewed Terraform plans.
4. Add manual approval before infrastructure deployment.
5. Improve Terraform state management.
6. Integrate CI/CD with the Kubernetes GitOps platform.
