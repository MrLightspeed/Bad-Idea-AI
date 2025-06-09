#!/usr/bin/env bash
# Minimal environment setup for Bad-Idea-AI repository

set -euo pipefail

# Ensure Node.js and npm are available
if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js is required." >&2
  exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is required." >&2
  exit 1
fi

echo "Node $(node -v)"
echo "npm  $(npm -v)"

# Install dependencies if package-lock.json is present
if [[ -f package-lock.json ]]; then
  echo "Installing npm dependencies (if available)..."
  npm ci --ignore-scripts >/dev/null 2>&1 || \
    echo "npm install skipped (likely offline)"
fi

echo "Setup complete."
