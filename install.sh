#!/bin/bash
# Bootstrap installer - downloads and runs the full installer interactively

set -e

REPO_RAW_URL="https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main"
TEMP_INSTALLER="/tmp/claude-toolkit-installer-$$.sh"

# Download the full installer
echo "📥 Downloading installer..."
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_RAW_URL/install-remote.sh" -o "$TEMP_INSTALLER"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_RAW_URL/install-remote.sh" -O "$TEMP_INSTALLER"
else
    echo "❌ Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Make it executable
chmod +x "$TEMP_INSTALLER"

# Run the installer with all arguments passed through
echo "🚀 Starting installation..."
echo ""
bash "$TEMP_INSTALLER" "$@"

# Clean up
rm -f "$TEMP_INSTALLER"
