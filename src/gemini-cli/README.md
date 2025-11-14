
# Gemini CLI (gemini-cli)

Installs the Google Gemini CLI tool for interacting with Google's Gemini AI models

## Example Usage

```json
"features": {
    "ghcr.io/devcontainers/feature-starter/gemini-cli:1": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of gemini-cli to install | string | latest |
| apiKey | Optional: Google API key for Gemini (can also be set via environment variable GEMINI_API_KEY) | string | - |

## Usage

After installation, you can use the `gemini-cli` command to interact with Google's Gemini AI models:

```bash
# Send a prompt to Gemini
gemini-cli "What is the capital of France?"

# Show version information
gemini-cli --version
```

## Configuration

You need to provide a Google API key to use the Gemini CLI. You can do this in two ways:

1. **Via devcontainer.json** (feature option):
```json
"features": {
    "ghcr.io/devcontainers/feature-starter/gemini-cli:1": {
        "apiKey": "your-api-key-here"
    }
}
```

2. **Via environment variable**:
```json
"containerEnv": {
    "GEMINI_API_KEY": "your-api-key-here"
}
```

To get a Google API key, visit: https://makersuite.google.com/app/apikey

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/devcontainers/feature-starter/blob/main/src/gemini-cli/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

