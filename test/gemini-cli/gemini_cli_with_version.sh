#!/bin/bash

# This test corresponds to the 'gemini_cli_with_version' scenario in scenarios.json

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "gemini-cli command exists" which gemini-cli
check "gemini-cli is executable" test -x /usr/local/bin/gemini-cli
check "python3 is installed" python3 --version
check "google-generativeai package is installed" python3 -c "import google.generativeai"
check "gemini-cli version flag works" gemini-cli --version 2>&1 | grep "Gemini CLI"

# Report result
reportResults

