#!/bin/bash

set -e

TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/Project Templates/visionOS/Application/SharePlay Spatial Experience.xctemplate"

echo "Installing SharePlay Spatial Experience Xcode template..."

# Create the template directory
mkdir -p "$TEMPLATE_DIR"

# Copy all template files
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATE_SOURCE="$SCRIPT_DIR/Xcode Templates/SharePlay Spatial Experience.xctemplate"

if [ -d "$TEMPLATE_SOURCE" ]; then
    cp -R "$TEMPLATE_SOURCE/" "$TEMPLATE_DIR/"
    echo "Template installed successfully to:"
    echo "  $TEMPLATE_DIR"
    echo ""
    echo "To use the template:"
    echo "1. Restart Xcode if it's running"
    echo "2. Create a new project (File > New > Project)"
    echo "3. Select 'visionOS' > 'Application'"
    echo "4. Choose 'SharePlay Spatial Experience'"
else
    echo "Error: Template source directory not found at: $TEMPLATE_SOURCE"
    exit 1
fi
