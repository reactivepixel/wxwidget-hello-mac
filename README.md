# wxWidgets-micro-sample #

This is a sample app to demonstrate use of wxWidgets. Originally designed for Windows with vcpkg, now supports both Windows and macOS.

## Requirements ##

### Windows ###
* Windows
* Visual Studio 2017 (similar versions may work)
* x86, dynamically-linked wxWidgets installed by vcpkg (use `vcpkg install wxwidgets`)

### macOS ###
* macOS
* Xcode Command Line Tools (for g++ and make)
* vcpkg or Homebrew (for wxWidgets installation)
* wxWidgets library

## Instructions ##

### Windows ###
* Make wxWidgets available with `vcpkg integrate install`
* Clone this repo
* Open the Visual Studio solution and hit F5 to build & run

### macOS ###

#### Quick Start with vcpkg (Recommended) ####
```bash
# Set up vcpkg and install wxWidgets
./setup-vcpkg.sh

# Set environment variable (add to your ~/.zshrc for persistence)
export VCPKG_ROOT="$HOME/vcpkg"

# Build the project
./build.sh
```

#### Quick Start with Homebrew ####
```bash
# Run the automated build script
./build.sh
```

#### Manual Build with vcpkg ####
```bash
# Install and set up vcpkg
git clone https://github.com/Microsoft/vcpkg.git ~/vcpkg
cd ~/vcpkg
./bootstrap-vcpkg.sh

# Set environment variable
export VCPKG_ROOT="$HOME/vcpkg"

# Install wxWidgets
make install-vcpkg-deps

# Build the project
make

# Run the program
make run
```

#### Manual Build with Homebrew ####
```bash
# Install dependencies (if not already installed)
make install-deps

# Check wxWidgets installation
make check-wx

# Build the project
make

# Run the program
make run
```

#### Alternative: Direct g++ Build ####
```bash
# With vcpkg (set VCPKG_ROOT environment variable first)
export VCPKG_ROOT="$HOME/vcpkg"
./build-gpp.sh

# Debug build
./build-gpp.sh --debug

# Verbose build (shows full g++ commands)
./build-gpp.sh --verbose

# Or manual g++ compilation
make debug      # Debug build
make verbose    # Verbose build
make            # Release build
```

## Build System ##
This project uses a **Makefile + g++** build system with C++17 standard. No CMake required!

### Available Build Targets ###
```bash
make            # Release build
make debug      # Debug build with symbols
make verbose    # Build with full command output
make clean      # Clean build files
make run        # Build and run
make help       # Show all available targets
```

## Things to note ##
* The project file contains no wxWidgets targeting information. No include paths, no library paths.
* This is very much not a "wxWidgets sample app". Try https://docs.wxwidgets.org/trunk/overview_helloworld.html for that.
* There were a couple of preprocessor definitions required to make this standard Visual Studio boilerplate project work with wxWidgets, see the commit history.
