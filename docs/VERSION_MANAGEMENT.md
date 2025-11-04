# Version Management Guide

## Overview

This project uses `config.yaml` as the single source of truth for all
dependency versions. The Dockerfile and CI/CD workflows automatically read
versions from this file.

## Managing Versions

### Update Versions

Edit `config.yaml` to update dependency versions:

```yaml
atlantis:
  version: 0.28.5
tg_atlantis_config:
  version: 1.18.0
terraform:
  version: 1.9.3
terragrunt:
  version: 0.64.4
```

### Local Builds

Use the build script that automatically reads from `config.yaml`:

```sh
./scripts/build.sh
```

Or set custom image name/tag:

```sh
IMAGE_NAME=my-atlantis IMAGE_TAG=dev ./scripts/build.sh
```

### CI/CD Automation

Both `build.yml` and `release.yml` workflows automatically:

1. Read versions from `config.yaml`
2. Pass them as build arguments to Docker
3. Build and push images with correct versions

### Manual Docker Build

If needed, you can still build manually:

```sh
docker build \
  --build-arg ATLANTIS_VERSION=0.28.5 \
  --build-arg TG_ATLANTIS_CONFIG_VER=1.18.0 \
  --build-arg TF_VERSION=1.9.3 \
  --build-arg TG_VERSION=0.64.4 \
  -t opseng-op-atlantis .
```

## Benefits

- **Single Source of Truth**: All versions in one place
- **Automated**: CI/CD reads versions automatically
- **Default Values**: Dockerfile has sensible defaults
- **Easy Updates**: Change one file, rebuild everywhere
- **Version Tracking**: Git history shows all version changes
