#!/bin/bash

# Build script for wxWidgets-micro-sample on macOS

set -e  # Exit on any error

echo "=== wxWidgets Micro Sample Build Script ==="
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
echo "Checking build requirements..."

if ! command_exists "make"; then
    echo "Error: make is not installed. Please install Xcode Command Line Tools:"
    echo "  xcode-select --install"
    exit 1
fi

if ! command_exists "g++"; then
    echo "Error: g++ is not installed. Please install Xcode Command Line Tools:"
    echo "  xcode-select --install"
    exit 1
fi

echo "✓ Build tools found"

echo
echo "Building project with g++ and Makefile..."
echo "C++ Standard: C++17"
echo

# Check for vcpkg first
if [ -n "$VCPKG_ROOT" ] && [ -d "$VCPKG_ROOT" ]; then
    echo "✓ vcpkg found at: $VCPKG_ROOT"
    
    # Check if wxWidgets is installed via vcpkg
    VCPKG_INSTALLED="$VCPKG_ROOT/installed/$(uname -m)-osx"
    if [ ! -d "$VCPKG_INSTALLED" ]; then
        echo "Installing wxWidgets via vcpkg..."
        cd "$VCPKG_ROOT"
        ./vcpkg install wxwidgets
    else
        echo "✓ wxWidgets found in vcpkg"
    fi
else
    echo "⚠️  vcpkg not found. Checking for system wxWidgets..."
    
    # Check for wxWidgets
    if ! command_exists "wx-config"; then
        echo "⚠️  wxWidgets not found. You have two options:"
        echo ""
        echo "Option 1: Install via vcpkg (recommended)"
        echo "  ./setup-vcpkg.sh"
        echo ""
        echo "Option 2: Install via Homebrew"
        echo "  brew install wxwidgets"
        echo ""
        read -p "Install via Homebrew now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if ! command_exists "brew"; then
                echo "Error: Homebrew is not installed. Please install it first:"
                echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                exit 1
            fi
            
            echo "Installing wxWidgets..."
            brew install wxwidgets
            echo "✓ wxWidgets installed"
        else
            exit 1
        fi
    else
        echo "✓ wxWidgets found: $(wx-config --version)"
    fi
fi

echo
echo "Building project..."

# Clean previous build
make clean

# Build the project
make

echo
echo "✓ Build completed successfully!"
echo "Run the program with: ./wxWidgets-micro-sample"
echo "Or use: make run"
