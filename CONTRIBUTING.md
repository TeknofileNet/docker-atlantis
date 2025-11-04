# Contributing Guidelines

## Branch Naming Conventions

Branches should use semantic prefixes to indicate their purpose:

- `feature/short-description` for new features
- `fix/short-description` for bug fixes
- `chore/short-description` for maintenance or build changes
- `docs/short-description` for documentation updates
- `ci/short-description` for CI/CD changes

Examples:

- `feature/add-kubectl-support`
- `fix/dockerfile-permissions`
- `docs/update-readme`


## Installed Tools & Dependency Management

The container includes the following tools (all versions managed via `config.yaml`):

- Atlantis
- Terragrunt
- Terraform
- tgenv
- terragrunt-atlantis-config
- kubectl
- Helm

To update a tool version, edit `config.yaml` and follow the standard PR process.

## Commit Message Format

This project uses [Conventional Commits](https://www.conventionalcommits.org/)
format for all commit messages. This is **required** for our automated release
and versioning system to work properly.

### Format

Commit messages must follow this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature (triggers minor version bump)
- **fix**: A bug fix (triggers patch version bump)
- **chore**: Changes to build process or auxiliary tools
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **ci**: Changes to CI configuration files and scripts

### Examples

✅ **Good commit messages:**

```
feat: add support for Terraform 1.9.3
fix: resolve docker build tag issue when run manually
chore: update pre-commit hooks to latest versions
docs: update README with new installation instructions
fix(atlantis): correct SSH key permissions
feat(ci)!: migrate to new runner infrastructure
```

❌ **Bad commit messages (will break releases):**

```
Fix/docker build (#16)           # Missing colon after type
Updated readme                    # No type specified
WIP                              # Not descriptive
feat add new feature             # Missing colon
```

### Breaking Changes

For breaking changes, add `!` after the type or add `BREAKING CHANGE:` in the
footer:

```
feat!: drop support for Terraform 1.7.x

BREAKING CHANGE: Minimum required Terraform version is now 1.8.0
```

### Why This Matters

Our release automation (release-please) parses commit messages to:

1. **Determine version bumps**: `feat` increases minor version, `fix` increases
   patch version, `BREAKING CHANGE` increases major version
2. **Generate changelogs**: Commit messages become release notes
3. **Create releases and tags**: Automatically creates GitHub releases and git tags

## Release Process: What Developers Should Expect

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

**If commit messages don't follow the format, releases won't be created!**

### Enforcement

Commit message format is enforced by:

- **Pre-commit hooks**: commitlint runs locally before commits
- **GitHub Actions**: CI checks commit messages in PRs
- **Pull Request titles**: PR titles should also follow this format as they
  become merge commit messages

### Setting Up Pre-commit Hooks

To ensure your commits follow the correct format:

```sh
./scripts/setup-precommit.sh
```

This will install commitlint and other linters that run automatically before
each commit.

### Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Commitlint Documentation](https://commitlint.js.org/)
- [Release Please Documentation](https://github.com/googleapis/release-please)
