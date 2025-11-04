#!/usr/bin/env bash

set -e

echo "🚀 Setting up pre-commit hooks for opseng-op-atlantis..."
echo ""

# Check if running on macOS or Linux
OS="$(uname -s)"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip3 first."
    exit 1
fi

echo "✅ pip3 found"
echo ""

# Check if pre-commit is already installed
if command -v pre-commit &> /dev/null; then
    echo "✅ pre-commit is already installed: $(pre-commit --version)"
    PRECOMMIT="pre-commit"
else
    # Install pre-commit
    echo "📦 Installing pre-commit..."
    pip3 install --user pre-commit

    # Verify installation
    if ! command -v pre-commit &> /dev/null; then
        echo "⚠️  pre-commit command not found in PATH."
        echo "   You may need to add ~/.local/bin to your PATH"
        echo "   Add this to your ~/.zshrc or ~/.bashrc:"
        echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        # Try to use it with full path
        PRECOMMIT="$HOME/.local/bin/pre-commit"
    else
        PRECOMMIT="pre-commit"
    fi

    echo "✅ pre-commit installed"
fi
echo ""

# Install the git hook scripts
echo "🔧 Installing git hook scripts..."
$PRECOMMIT install
$PRECOMMIT install --hook-type commit-msg

echo "✅ Git hooks installed"
echo ""

# Check for Node.js and install commitlint if available
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    echo "📦 Installing commitlint dependencies..."
    npm install --save-dev @commitlint/config-conventional 2>/dev/null || \
        echo "   ⚠️  Could not install commitlint deps. Commit message linting will use pre-commit hook."
    echo "✅ Commitlint dependencies ready"
else
    echo "⚠️  Node.js/npm not found. Commitlint will still work via pre-commit hook."
fi
echo ""

# Install additional dependencies based on OS
echo "📦 Installing additional linting tools..."

if [[ "$OS" == "Darwin" ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        echo "   Installing via Homebrew..."
        brew install hadolint shellcheck actionlint markdownlint-cli yamllint || true
    else
        echo "   ⚠️  Homebrew not found. Please install Homebrew or manually install:"
        echo "      - hadolint (Dockerfile linter)"
        echo "      - shellcheck (Shell script linter)"
        echo "      - actionlint (GitHub Actions linter)"
        echo "      - markdownlint-cli (Markdown linter)"
        echo "      - yamllint (YAML linter)"
    fi
elif [[ "$OS" == "Linux" ]]; then
    # Linux
    echo "   Note: Some tools may need manual installation on Linux"
    echo "   Installing yamllint via pip..."
    pip3 install --user yamllint
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎉 Pre-commit hooks are now installed and will run automatically on git commit."
echo ""
echo "Optional: To run pre-commit on all files now, execute:"
echo "   pre-commit run --all-files"
echo ""
echo "To update hooks to the latest versions:"
echo "   pre-commit autoupdate"
