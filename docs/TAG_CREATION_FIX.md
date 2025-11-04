# Fix: Tag Creation Issue

## Problem

The release-please action failed to create a new tag for version 1.0.1 after
PR #16 was merged to main. The workflow completed successfully, but no release
or tag was created.

## Root Cause

The commit message from PR #16 was: `Fix/docker build (#16)`

Release-please uses [Conventional Commits](https://www.conventionalcommits.org/)
format to determine:

1. Whether to create a new release
2. What version number to use (major/minor/patch)
3. What to include in the changelog

The commit message parser failed with this error:

```
commit could not be parsed: 33ed1e5c92a5ae7c20fac5933440361957f7cc55 Fix/docker build (#16)
error message: Error: unexpected token ' ' at 1:11, valid tokens [(, !, :]
```

The issue is that `Fix/docker build` doesn't follow the required format. It
should have been `fix: docker build` (with a colon after the type).

## Solution Implemented

To prevent this issue from happening again, the following changes were made:

### 1. Documentation

- **CONTRIBUTING.md**: Comprehensive guide on Conventional Commits format with
  examples of correct and incorrect commit messages
- **README.md**: Added reference to CONTRIBUTING.md in the Development section
- **BRANCHING.md**: Added note about commit message format requirement

### 2. Automated Validation

- **commitlint**: Added commitlint configuration (`.commitlintrc.yaml`) and
  pre-commit hook to validate commit messages locally before they are pushed
- **PR Title Validation**: Added GitHub Actions workflow (`.github/workflows/validate-pr.yml`)
  to validate that PR titles follow Conventional Commits format
- **package.json**: Added commitlint dependencies for local development

### 3. Setup Improvements

- **setup-precommit.sh**: Updated to install commit-msg hooks and commitlint
  dependencies

## Conventional Commits Format

The required format is:

```
<type>[optional scope]: <description>
```

Valid types:

- `feat`: New feature (minor version bump)
- `fix`: Bug fix (patch version bump)
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test changes
- `style`: Code style changes
- `build`: Build system changes

## Example Corrections

| ❌ Incorrect | ✅ Correct |
|--------------|------------|
| `Fix/docker build` | `fix: docker build` |
| `Update README` | `docs: update README` |
| `WIP` | `chore: work in progress` |
| `feat add feature` | `feat: add feature` |

## Future Releases

Now that these safeguards are in place:

1. **Local commits** will be validated by commitlint before being committed
2. **PR titles** will be validated before PRs can be merged
3. **Contributors** have clear documentation on the required format

The next commit to main with a valid conventional commit message will trigger
a new release with the appropriate version bump.

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Release Please Documentation](https://github.com/googleapis/release-please)
- [Commitlint Documentation](https://commitlint.js.org/)
