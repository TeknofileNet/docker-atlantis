# Branching Strategy for Docker Container Repositories

## Dependency Updates

All tool and component versions (Atlantis, Terragrunt, Terraform, tgenv, terragrunt-atlantis-config, kubectl, Helm) are managed in `config.yaml`.

To update a dependency version, create a feature branch, edit `config.yaml`, and open a pull request for review and CI.

## Recommended Strategy: GitHub Flow

For Docker container repositories, the most commonly used branching strategy
is **GitHub Flow**. This approach is simple, effective, and well-suited for
continuous integration and delivery workflows typical of containerized
projects.

### Key Points of GitHub Flow

- **Main Branch**: The `main` branch always contains production-ready code.
- **Feature Branches**: Create a new branch for each feature, bugfix, or
  update (e.g., `feature/add-logging`, `fix/dockerfile-typo`).
- **Pull Requests**: Open a pull request from your feature branch to `main`
  when your work is ready for review.
- **Review & CI**: All changes are reviewed and tested via CI before merging.
- **Merge & Deploy**: Once approved, merge the pull request. Automated
  workflows (e.g., GitHub Actions) can build and publish new container images.

### Example Workflow

1. Branch from `main`:

   ```sh
   git checkout -b feature/my-new-feature
   ```

2. Make changes and commit:

   ```sh
   git commit -am "feat: add my new feature"
   ```

   **Important**: Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/)
   format. See [CONTRIBUTING.md](CONTRIBUTING.md) for details. This is required
   for automated releases and versioning.

3. Push and open a pull request:

   ```sh
   git push origin feature/my-new-feature
   ```

4. Review, test, and merge into `main`.

## Additional Best Practices

- Use semantic branch names (`feature/`, `fix/`, `chore/`, etc.)
- Keep feature branches short-lived
- Use pull request templates for consistency
- Tag releases for traceability (e.g., `v1.0.0`)

## Branch Naming Conventions

Branches should be named using the following prefixes to indicate their purpose:

- `feature/short-description` for new features
- `fix/short-description` for bug fixes
- `chore/short-description` for maintenance or build changes
- `docs/short-description` for documentation updates
- `ci/short-description` for CI/CD changes

Examples:

- `feature/add-kubectl-support`
- `fix/dockerfile-permissions`
- `docs/update-readme`

## Commit Message Requirements

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) format. This is required for automated releases and changelogs. See [CONTRIBUTING.md](CONTRIBUTING.md) for details and examples.

## Release Process: What to Expect

This repository uses the [release-please](https://github.com/googleapis/release-please) workflow for automated releases:


### What Triggers a Release?

Release Please will only generate a new release PR if there are user-facing Conventional Commits since the last release:

- **Triggers a release:**
  - `feat:` (features)
  - `fix:` (bug fixes)
  - Commits with breaking changes (`!` or `BREAKING CHANGE:`)
- **Does NOT trigger a release:**
  - `docs:` (documentation)
  - `chore:` (maintenance)
  - `style:`, `refactor:`, `test:`, `ci:`

If only non-user-facing commits are present, no new release PR will be created. To force a release, include a `feat:` or `fix:` commit in your changes.

## References

- [GitHub Flow Documentation](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
