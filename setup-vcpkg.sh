#!/bin/bash

# vcpkg setup script for wxWidgets-micro-sample on macOS

set -e  # Exit on any error

echo "=== vcpkg Setup Script ==="
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
echo "Checking requirements..."

if ! command_exists "git"; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

if ! command_exists "cmake"; then
    echo "Warning: cmake not found, but not required for this project (uses g++ + Makefile)"
fi

echo "✓ Required tools found"

# Check if vcpkg is already set up
if [ -n "$VCPKG_ROOT" ] && [ -d "$VCPKG_ROOT" ]; then
    echo "✓ vcpkg found at: $VCPKG_ROOT"
else
    echo "Setting up vcpkg..."
    
    # Default vcpkg location
    VCPKG_DIR="$HOME/vcpkg"
    
    if [ ! -d "$VCPKG_DIR" ]; then
        echo "Cloning vcpkg..."
        git clone https://github.com/Microsoft/vcpkg.git "$VCPKG_DIR"
    fi
    
    echo "Bootstrapping vcpkg..."
    cd "$VCPKG_DIR"
    ./bootstrap-vcpkg.sh
    
    echo ""
    echo "⚠️  Please add the following to your shell profile (~/.zshrc or ~/.bash_profile):"
    echo "export VCPKG_ROOT=\"$VCPKG_DIR\""
    echo ""
    echo "Then restart your terminal or run:"
    echo "export VCPKG_ROOT=\"$VCPKG_DIR\""
    
    export VCPKG_ROOT="$VCPKG_DIR"
fi

# Install wxWidgets
echo ""
echo "Installing wxWidgets via vcpkg..."
cd "$VCPKG_ROOT"
./vcpkg install wxwidgets

echo ""
echo "✓ vcpkg setup completed!"
echo ""
echo "To build the project with g++:"
echo "  1. Ensure VCPKG_ROOT is set: export VCPKG_ROOT=\"$VCPKG_ROOT\""
echo "  2. Build with make: make"
echo "  3. Or use the build script: ./build-gpp.sh"
echo "  4. Debug build: make debug"
echo "  5. Verbose build: make verbose"
