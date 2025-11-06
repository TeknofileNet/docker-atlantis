#!/usr/bin/env bash

set -e

# Script to build Docker image with versions from config.yaml
# Usage: ./scripts/build.sh [IMAGE_TAG]
#   IMAGE_TAG: Optional tag for the image (default: latest)
#   IMAGE_NAME: Optional image name (default: docker-atlantis)
#
# Example: IMAGE_NAME=myrepo/atlantis IMAGE_TAG=dev ./scripts/build.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/config.yaml"

# Check if config.yaml exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: config.yaml not found at $CONFIG_FILE"
    exit 1
fi

# Extract versions from config.yaml using grep and awk
echo "📦 Reading versions from config.yaml..."

ATLANTIS_VERSION=$(grep -A1 "^atlantis:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')
TG_ATLANTIS_CONFIG_VER=$(grep -A1 "^tg_atlantis_config:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')
TF_VERSION=$(grep -A1 "^terraform:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')
TG_VERSION=$(grep -A1 "^terragrunt:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')
KUBECTL_VERSION=$(grep -A1 "^kubectl:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')
HELM_VERSION=$(grep -A1 "^helm:" "$CONFIG_FILE" | grep "version:" | awk '{print $2}')

# Validate all versions were read successfully
for var in ATLANTIS_VERSION TG_ATLANTIS_CONFIG_VER TF_VERSION TG_VERSION KUBECTL_VERSION HELM_VERSION; do
    if [ -z "${!var}" ]; then
        echo "❌ Error: Failed to read $var from config.yaml"
        exit 1
    fi
done

echo "  Atlantis: $ATLANTIS_VERSION"
echo "  Terragrunt Atlantis Config: $TG_ATLANTIS_CONFIG_VER"
echo "  Terraform: $TF_VERSION"
echo "  Terragrunt: $TG_VERSION"
echo "  Kubectl: $KUBECTL_VERSION"
echo "  Helm: $HELM_VERSION"
echo ""

# Build the Docker image
IMAGE_NAME="${IMAGE_NAME:-docker-atlantis}"
IMAGE_TAG="${1:-${IMAGE_TAG:-latest}}"

echo "🔨 Building Docker image: $IMAGE_NAME:$IMAGE_TAG"
echo ""

docker build \
  --build-arg ATLANTIS_VERSION="$ATLANTIS_VERSION" \
  --build-arg TG_ATLANTIS_CONFIG_VER="$TG_ATLANTIS_CONFIG_VER" \
  --build-arg TF_VERSION="$TF_VERSION" \
  --build-arg TG_VERSION="$TG_VERSION" \
  --build-arg KUBECTL_VERSION="$KUBECTL_VERSION" \
  --build-arg HELM_VERSION="$HELM_VERSION" \
  -t "$IMAGE_NAME:$IMAGE_TAG" \
  "$PROJECT_ROOT"

echo ""
echo "✅ Build complete: $IMAGE_NAME:$IMAGE_TAG"
