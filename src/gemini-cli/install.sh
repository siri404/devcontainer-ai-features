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
apt-get update -y
apt-get install -y --no-install-recommends curl python3 python3-pip python3-venv

# Install gemini-cli using pip
echo "Installing google-generativeai package..."
pip3 install --no-cache-dir google-generativeai

# Create a wrapper script for gemini-cli
cat > /usr/local/bin/gemini-cli << 'EOF'
#!/usr/bin/env python3
import os
import sys

def main():
    # If no arguments, show help
    if len(sys.argv) < 2:
        print("Gemini CLI - Interact with Google's Gemini AI models")
        print("\nUsage:")
        print("  gemini-cli <prompt>           Send a prompt to Gemini")
        print("  gemini-cli --version          Show version information")
        print("\nExample:")
        print("  gemini-cli 'What is the capital of France?'")
        print("\nConfiguration:")
        print("  Set GEMINI_API_KEY environment variable or configure apiKey in devcontainer.json")
        sys.exit(0)
    
    # Import here to avoid errors if just showing help
    try:
        import google.generativeai as genai
    except ImportError:
        print("Error: google-generativeai package not found", file=sys.stderr)
        print("Please ensure the feature is properly installed", file=sys.stderr)
        sys.exit(1)
    
    if sys.argv[1] == '--version':
        print("Gemini CLI version 1.0.0")
        try:
            print(f"google-generativeai version: {genai.__version__}")
        except:
            print("google-generativeai package installed")
        sys.exit(0)
    
    # Get API key from environment or feature option
    api_key = os.environ.get('GEMINI_API_KEY', '')
    
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable not set", file=sys.stderr)
        print("Please set GEMINI_API_KEY or configure apiKey option in devcontainer.json", file=sys.stderr)
        print("\nTo get an API key, visit: https://makersuite.google.com/app/apikey", file=sys.stderr)
        sys.exit(1)
    
    genai.configure(api_key=api_key)
    
    # Join all arguments as the prompt
    prompt = ' '.join(sys.argv[1:])
    
    try:
        # Use gemini-pro model
        model = genai.GenerativeModel('gemini-pro')
        response = model.generate_content(prompt)
        print(response.text)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
EOF

chmod +x /usr/local/bin/gemini-cli

echo "Gemini CLI installation complete!"
echo "Use 'gemini-cli' to interact with Google's Gemini AI models"

