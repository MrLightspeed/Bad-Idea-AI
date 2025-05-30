#!/usr/bin/env bash
# Setup script for Bad-Idea-AI environment
# Purpose: Prepare environment for repository management
# Usage: ./setup.sh [--offline|--online]

set -euo pipefail

# Default to online mode
MODE="online"

# Parse command line arguments
for arg in "$@"; do
  case "$arg" in
    --offline)
      MODE="offline"
      ;;
    --online)
      MODE="online"
      ;;
    --help|-h)
      echo "Usage: $0 [--offline|--online]"
      echo "  --online   Download packages from npm registry (default)"
      echo "  --offline  Use cached packages only"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check for environment variable override
if [[ -n "${OFFLINE:-}" ]]; then
  MODE="offline"
fi

echo "==================================="
echo "Bad-Idea-AI Environment Setup"
echo "Mode: $MODE"
echo "==================================="
echo

# Clean environment to avoid npm warnings
unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY 2>/dev/null || true

# Function to check if Node.js is installed
check_node() {
  if ! command -v node >/dev/null 2>&1; then
    echo "Error: Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
  fi
  
  local node_version=$(node -v)
  echo "✓ Node.js $node_version found"
}

# Function to check if npm is installed
check_npm() {
  if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is not installed"
    echo "Please install npm (usually comes with Node.js)"
    exit 1
  fi
  
  local npm_version=$(npm -v 2>/dev/null)
  echo "✓ npm $npm_version found"
}

# Function to install npm dependencies
install_npm_deps() {
  echo
  echo "Installing npm dependencies..."
  
  if [[ ! -f "package.json" ]]; then
    echo "Error: No package.json found in current directory"
    exit 1
  fi
  
  if [[ "$MODE" == "online" ]]; then
    # Online installation
    if [[ -f "package-lock.json" ]]; then
      echo "Using npm ci for clean installation..."
      npm ci
    else
      echo "No package-lock.json found, using npm install..."
      npm install
    fi
    
    # Check and report issues
    echo
    echo "Checking for issues..."
    
    npm audit 2>/dev/null || true
    
    # Note about deprecated packages
    if grep -q "nomnom\|inflight" package.json 2>/dev/null; then
      echo
      echo "Note: Some dependencies are deprecated and should be updated:"
      echo "  - nomnom: Consider migrating to yargs or commander"
      echo "  - inflight: Functionality now available in lru-cache"
    fi
    
  else
    # Offline installation
    npm config set offline true
    
    if [[ -f "package-lock.json" ]]; then
      npm ci --offline || {
        echo "Error: Offline installation failed"
        echo "Run setup in online mode first to cache dependencies"
        exit 1
      }
    else
      echo "Error: Cannot install offline without package-lock.json"
      exit 1
    fi
    
    npm config delete offline
  fi
  
  echo "✓ npm dependencies installed"
}

# Function to install Ruby dependencies if Gemfile exists
install_ruby_deps() {
  if [[ -f "Gemfile" ]]; then
    echo
    echo "Installing Ruby dependencies..."
    
    if ! command -v bundle >/dev/null 2>&1; then
      echo "Warning: Bundler not found, skipping Ruby dependencies"
      echo "Install bundler with: gem install bundler"
      return
    fi
    
    if [[ "$MODE" == "online" ]]; then
      bundle install
    else
      bundle install --local 2>/dev/null || echo "Warning: Some gems may be missing in offline mode"
    fi
    
    echo "✓ Ruby dependencies installed"
  fi
}

# Main setup flow
main() {
  # Check prerequisites
  check_node
  check_npm
  
  # Install dependencies
  install_npm_deps
  install_ruby_deps
  
  # Setup complete
  echo
  echo "==================================="
  echo "✓ Setup complete!"
  echo "==================================="
  echo
  echo "The environment is ready for AI repository management."
  
  # Final recommendations
  if [[ "$MODE" == "online" ]]; then
    echo
    echo "Recommendations:"
    echo "  • Run 'npm audit fix' to address security vulnerabilities"
    echo "  • Update deprecated packages when possible"
    echo "  • Keep dependencies up to date with 'npm update'"
  fi
}

# Run main setup
main
