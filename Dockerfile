# syntax=docker/dockerfile:1

# Define global build arguments (needed before FROM for base image selection)
ARG ATLANTIS_VERSION=0.28.5

# Build stage for dependencies
FROM art01.corp.pingidentity.com:5400/debian:bookworm-slim AS debian-base

# Define build arguments with defaults from config.yaml
ARG TARGETPLATFORM
ARG ATLANTIS_VERSION
ARG TG_ATLANTIS_CONFIG_VER=1.18.0
ARG TF_VERSION=1.9.3
ARG TG_VERSION=0.64.4
ARG KUBECTL_VERSION=1.31.2
ARG HELM_VERSION=3.16.2

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in a single layer with proper cleanup
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        unzip \
        dumb-init \
        gnupg \
        apt-transport-https \
        openssl && \
    rm -rf /var/lib/apt/lists/*

# Install tgenv and terragrunt
RUN --mount=type=cache,target=/root/.cache \
    mkdir -p /opt/tgenv && \
    git clone --depth=1 https://github.com/cunymatthieu/tgenv.git /opt/tgenv && \
    ln -s /opt/tgenv/bin/* /usr/local/bin/ && \
    tgenv install "${TG_VERSION}" && \
    tgenv use "${TG_VERSION}"

# Install terragrunt-atlantis-config
RUN curl -fsSL "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TG_ATLANTIS_CONFIG_VER}/terragrunt-atlantis-config_${TG_ATLANTIS_CONFIG_VER}_linux_amd64" \
    -o /usr/local/bin/terragrunt-atlantis-config && \
    chmod +x /usr/local/bin/terragrunt-atlantis-config

# Install kubectl
RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install Helm
RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    -o /tmp/helm.tar.gz && \
    tar -zxvf /tmp/helm.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf /tmp/helm.tar.gz /tmp/linux-amd64

# Final stage
FROM ghcr.io/runatlantis/atlantis:v${ATLANTIS_VERSION}

# Re-declare build args for use in this stage
ARG ATLANTIS_VERSION
ARG TG_ATLANTIS_CONFIG_VER
ARG TF_VERSION
ARG TG_VERSION
ARG KUBECTL_VERSION
ARG HELM_VERSION

# Metadata labels following OCI standards
LABEL org.opencontainers.image.title="opseng-op-atlantis"
LABEL org.opencontainers.image.description="Custom Atlantis image with Terragrunt support"
LABEL org.opencontainers.image.authors="Operational Platforms <sreop@pingidentity.com>"
LABEL org.opencontainers.image.vendor="Ping Identity"
LABEL org.opencontainers.image.source="https://github.com/ping-internal/opseng-op-atlantis"

# Copy binaries and tools from build stage
COPY --from=debian-base /usr/local/bin/terragrunt-atlantis-config /usr/local/bin/
COPY --from=debian-base /usr/local/bin/kubectl /usr/local/bin/
COPY --from=debian-base /usr/local/bin/helm /usr/local/bin/
COPY --from=debian-base /opt/tgenv /opt/tgenv

# Create symlinks for tgenv
RUN ln -s /opt/tgenv/bin/* /usr/local/bin/

# Set working directory
WORKDIR /atlantis

# Health check (if Atlantis exposes a health endpoint)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#   CMD curl -f http://localhost:4141/healthz || exit 1
