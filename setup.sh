#!/usr/bin/env bash
# Setup script for Bad-Idea-AI environment
# Usage: ./setup.sh [--offline|--online]
# Defaults to online mode if not specified.

set -euo pipefail

MODE="online"
for arg in "$@"; do
  case "$arg" in
    --offline)
      MODE="offline"
      ;;
    --online)
      MODE="online"
      ;;
  esac
 done

if [[ -n "${OFFLINE:-}" ]]; then
  MODE="offline"
fi

echo "Running setup in $MODE mode"

function install_node() {
  if ! command -v node >/dev/null; then
    echo "Node.js not found. Installing..."
    apt-get update
    apt-get install -y nodejs npm
  else
    echo "Node.js already installed"
  fi
}

function install_npm_deps() {
  if [ "$MODE" = "online" ]; then
    npm install
  else
    # Attempt offline install using cached packages
    if npm ci --offline; then
      echo "Dependencies installed from cache"
    else
      echo "Offline installation failed. Ensure npm cache is populated or run online setup first." >&2
      exit 1
    fi
  fi
}

if [ "$MODE" = "online" ]; then
  install_node
fi

install_npm_deps

echo "Setup complete"
