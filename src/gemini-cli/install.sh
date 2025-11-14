#!/bin/sh
set -e

echo "Activating feature 'gemini-cli'"
echo "Installing Gemini CLI version: ${VERSION}"

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

# Ensure required packages are installed
export DEBIAN_FRONTEND=noninteractive
echo "Installing dependencies..."

# Check if node/npm is already installed, if not install it
if ! command -v node > /dev/null 2>&1; then
    echo "Node.js not found, installing..."
    apt-get update -y
    apt-get install -y --no-install-recommends curl ca-certificates
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y --no-install-recommends nodejs
else
    echo "Node.js already installed: $(node --version)"
fi

# Install Google Gemini CLI via npm
echo "Installing @google/gemini-cli package..."
npm install -g @google/gemini-cli

# If an API key was provided, set it up in the environment
if [ -n "${APIKEY}" ] && [ "${APIKEY}" != "" ]; then
    echo "Setting up GEMINI_API_KEY environment variable..."
    
    # Add to /etc/environment for system-wide access
    echo "GEMINI_API_KEY=${APIKEY}" >> /etc/environment
    
    # Add to shell profiles for interactive shells
    cat >> /etc/profile.d/gemini-cli.sh << EOF
export GEMINI_API_KEY="${APIKEY}"
EOF
    chmod +x /etc/profile.d/gemini-cli.sh
    
    # Also set for bash users
    if [ -f "/etc/bash.bashrc" ]; then
        echo "export GEMINI_API_KEY=\"${APIKEY}\"" >> /etc/bash.bashrc
    fi
    
    # Set for zsh users
    if [ -d "/etc/zsh" ]; then
        echo "export GEMINI_API_KEY=\"${APIKEY}\"" >> /etc/zsh/zshenv
    fi
    
    echo "API key configured successfully"
else
    echo "No API key provided. You can set it later via GEMINI_API_KEY environment variable"
fi

echo "Gemini CLI installation complete!"
echo "Use 'gemini' command to interact with Google's Gemini AI models"


