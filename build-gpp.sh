#!/bin/bash

# Simple g++ build script for wxWidgets-micro-sample on macOS

set -e  # Exit on any error

echo "=== wxWidgets g++ Build Script ==="
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

echo "✓ Build tools found (make, g++)"

# Check for vcpkg first
if [ -n "$VCPKG_ROOT" ] && [ -d "$VCPKG_ROOT" ]; then
    echo "✓ vcpkg found at: $VCPKG_ROOT"
    
    # Detect architecture
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        VCPKG_TRIPLET="arm64-osx"
    else
        VCPKG_TRIPLET="x64-osx"
    fi
    
    # Check if wxWidgets is installed via vcpkg
    VCPKG_INSTALLED="$VCPKG_ROOT/installed/$VCPKG_TRIPLET"
    if [ ! -d "$VCPKG_INSTALLED" ]; then
        echo "Installing wxWidgets via vcpkg..."
        cd "$VCPKG_ROOT"
        ./vcpkg install wxwidgets:$VCPKG_TRIPLET
    else
        echo "✓ wxWidgets found in vcpkg for $VCPKG_TRIPLET"
    fi
else
    echo "⚠️  vcpkg not found. Checking for system wxWidgets..."
    
    # Check for wxWidgets
    if ! command_exists "wx-config"; then
        echo "⚠️  wxWidgets not found. You have two options:"
        echo ""
        echo "Option 1: Install via vcpkg (not recommended for Parallels users)"
        echo "  ./setup-vcpkg.sh"
        echo ""
        echo "Option 2: Install via Homebrew (recommended)"
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
echo "Building project with g++..."
echo "Build system: Makefile + g++ (C++17)"
echo

# Parse command line arguments
BUILD_TYPE="all"
VERBOSE=""

for arg in "$@"; do
    case $arg in
        -d|--debug)
            BUILD_TYPE="debug"
            echo "Debug build enabled"
            ;;
        -v|--verbose)
            VERBOSE="V=1"
            echo "Verbose output enabled"
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -d, --debug    Build with debug symbols"
            echo "  -v, --verbose  Show full compile commands"
            echo "  -h, --help     Show this help"
            exit 0
            ;;
    esac
done

# Clean previous build
make clean

# Build the project
if [ -n "$VERBOSE" ]; then
    make $BUILD_TYPE $VERBOSE
else
    make $BUILD_TYPE
fi

echo
echo "✓ Build completed successfully!"
echo "Executable: ./wxWidgets-micro-sample"
echo "Run with: ./wxWidgets-micro-sample"
echo "Or use: make run"
