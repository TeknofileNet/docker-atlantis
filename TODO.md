# TODO

## Dependency Management

All required tools are installed in the container and versioned via `config.yaml`:

- Atlantis
- Terragrunt
- Terraform
- tgenv
- terragrunt-atlantis-config
- kubectl
- Helm

To update a tool version, edit `config.yaml` and rebuild the image.

## Other TODOs

* Expose Atlantis configs via environment variables
* Add default configs for easier onboarding
