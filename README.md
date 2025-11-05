
# docker-atlantis

## Overview

This project provides a containerized deployment of
[Atlantis](https://www.runatlantis.io/), an open-source tool for automating
Terraform and Terragrunt workflows via pull requests. It is designed for use
within Ping Identity's internal infrastructure, leveraging custom base images
and configuration management.

## Features


## Installed Dependencies & Components

The container image includes the following tools and dependencies (all versions managed via `config.yaml`):

- **Atlantis**: Open-source Terraform/Terragrunt automation
- **Terragrunt**: Wrapper for Terraform for DRY infrastructure code
- **Terraform**: Infrastructure as Code engine
- **tgenv**: Terragrunt version manager
- **terragrunt-atlantis-config**: Atlantis config generator for Terragrunt
- **kubectl**: Kubernetes CLI for cluster management
- **Helm**: Kubernetes package manager
- **s6-overlay**: Process supervision and service management
- **System utilities**: curl, git, unzip, dumb-init, gnupg, openssl, ca-certificates, apt-transport-https

All versions are pinned in `config.yaml` and injected into the build via Dockerfile ARGs and CI/CD workflows.

## Directory Structure

```text
config.yaml                # Version pinning for dependencies
Dockerfile                 # Multi-stage build for Atlantis and dependencies
README.md                  # Project documentation
TODO.md                    # Pending tasks and improvements
root/
  config/
    run/
      atlantis             # Entrypoint script for Atlantis service
  etc/
    services.d/
      atlantis/
        run                # s6 service script for Atlantis
```

## Configuration

- **config.yaml**: Single source of truth for all dependency versions
  (Atlantis, Terragrunt, Terraform, etc.). Update versions here.
- **SSH Keys**: Place your Atlantis GitHub deploy key at
  `/config/keys/id_atlantisgithub`.
- **Atlantis Server Config**: Expected at `/config/etc/server.yaml`.

## Version Management

All dependency versions are managed in `config.yaml`. The Dockerfile uses
build arguments with defaults from this file.

To update versions:

1. Edit `config.yaml` with new version numbers
2. Build locally or push to trigger CI/CD

The build process automatically reads versions from `config.yaml`.

## Building the Image

### Using the build script (recommended)

The easiest way to build with versions from `config.yaml`:

```sh
./scripts/build.sh
```

### Manual build

Or build manually with specific versions:

```sh
docker build \
  --build-arg ATLANTIS_VERSION=0.28.5 \
  --build-arg TG_ATLANTIS_CONFIG_VER=1.18.0 \
  --build-arg TG_VERSION=0.64.4 \
  --build-arg TF_VERSION=1.9.3 \
  -t docker-atlantis .
```

## Running

Atlantis is started via s6-overlay scripts. The main entrypoint is:

- `root/config/run/atlantis`
- `root/etc/services.d/atlantis/run`

These scripts set up the environment and launch Atlantis with the specified
configuration.

## Environment Variables

- `GIT_SSH_COMMAND`: Used to specify the SSH key for GitHub access.

## Development

### Contributing

Before contributing, please read our [Contributing Guidelines](CONTRIBUTING.md)
which includes important information about:

- **Commit message format** (required for releases)
- Code style and linting requirements
- Pull request process

### Pre-commit Hooks

This project uses [pre-commit](https://pre-commit.com/) to ensure code quality
and consistency. Pre-commit hooks will automatically run linters and formatters
before each commit.

#### Setup

To set up pre-commit on your local machine:

```sh
./scripts/setup-precommit.sh
```

This script will:

- Install pre-commit
- Install git hook scripts
- Install additional linting tools (hadolint, shellcheck, actionlint, etc.)

#### Running Pre-commit

Pre-commit will run automatically on `git commit`. To run manually on all files:

```sh
pre-commit run --all-files
```

#### Linters Included

- **Dockerfile**: hadolint
- **Shell scripts**: shellcheck
- **GitHub Actions**: actionlint
- **Markdown**: markdownlint
- **YAML**: yamllint
- **General**: trailing whitespace, end-of-file fixer, etc.

### CI/CD

Pre-commit checks are also enforced in GitHub Actions. See
`.github/workflows/pre-commit.yml` for details.

## TODO

- Expose Atlantis configs via environment variables.
- Add default configs for easier onboarding.

## Maintainer

James Richardson (<jamesrichardson@pingidentity.com>)
