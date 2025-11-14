#!/bin/bash

# This test corresponds to the 'gemini_cli_with_version' scenario in scenarios.json

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "node is installed" node --version
check "npm is installed" npm --version
check "gemini command exists" which gemini
check "@google/gemini-cli package is installed" npm list -g @google/gemini-cli
check "gemini version flag works" gemini --version 2>&1

# Report result
reportResults

