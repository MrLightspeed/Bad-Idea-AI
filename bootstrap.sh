#!/usr/bin/env bash
# Bootstrap environment for Bad-Idea-AI

set -euo pipefail

# Ensure npm is available
if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is required." >&2
  exit 1
fi

# Install markdownlint-cli2 globally if not present
if ! command -v markdownlint >/dev/null 2>&1; then
  echo "Installing markdownlint-cli2..."
  npm install -g markdownlint-cli2 >/dev/null 2>&1 || \
    echo "markdownlint-cli2 install skipped (likely offline)"
fi

echo "Bootstrap complete."
