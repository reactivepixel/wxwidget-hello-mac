# Makefile for wxWidgets-micro-sample on macOS

# Compiler
CXX = g++

# Program name
PROGRAM = wxWidgets-micro-sample

# Source files
SOURCES = wxWidgets-micro-sample.cpp

# Object files
OBJECTS = $(SOURCES:.cpp=.o)

# Detect architecture for vcpkg
ARCH = $(shell uname -m)
ifeq ($(ARCH),arm64)
    VCPKG_TRIPLET = arm64-osx
else
    VCPKG_TRIPLET = x64-osx
endif

# Check if vcpkg is available
ifdef VCPKG_ROOT
    # Use vcpkg
    VCPKG_INSTALLED = $(VCPKG_ROOT)/installed/$(VCPKG_TRIPLET)
    
    # Check for different wxWidgets versions in vcpkg
    ifeq ($(wildcard $(VCPKG_INSTALLED)/include/wx-3.2),)
        WX_VERSION_DIR = $(shell find $(VCPKG_INSTALLED)/include -name "wx-*" -type d | head -n1)
        WX_VERSION = $(notdir $(WX_VERSION_DIR))
    else
        WX_VERSION = wx-3.2
    endif
    
    WX_CXXFLAGS = -I$(VCPKG_INSTALLED)/include -I$(VCPKG_INSTALLED)/include/$(WX_VERSION)
    WX_LIBS = -L$(VCPKG_INSTALLED)/lib -lwx_osx_cocoa_core-3.2 -lwx_base-3.2 -framework Cocoa -framework IOKit -framework Carbon -framework WebKit -framework AudioToolbox -framework Security
else
    # Use system wx-config
    WX_CONFIG = wx-config
    WX_CXXFLAGS = `$(WX_CONFIG) --cxxflags`
    WX_LIBS = `$(WX_CONFIG) --libs`
endif

# Compiler flags
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 $(WX_CXXFLAGS)
LDFLAGS = $(WX_LIBS)

# Default target
all: check-deps $(PROGRAM)

# Debug build
debug: CXXFLAGS += -g -DDEBUG
debug: check-deps $(PROGRAM)

# Verbose build (shows full compile commands)
verbose: check-deps
	@$(MAKE) $(PROGRAM) V=1

# Check dependencies
check-deps:
ifdef VCPKG_ROOT
	@echo "Using vcpkg from: $(VCPKG_ROOT)"
	@if [ ! -d "$(VCPKG_INSTALLED)" ]; then \
		echo "vcpkg packages not found. Run 'make install-vcpkg-deps' first."; \
		exit 1; \
	fi
else
	@echo "VCPKG_ROOT not set, using system wxWidgets"
	@if ! command -v wx-config >/dev/null 2>&1; then \
		echo "wx-config not found. Please install wxWidgets or set up vcpkg."; \
		exit 1; \
	fi
endif

# Build the program
$(PROGRAM): $(OBJECTS)
ifeq ($(V),1)
	$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)
else
	@echo "Linking $(PROGRAM)..."
	@$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)
endif

# Compile source files
%.o: %.cpp
ifeq ($(V),1)
	$(CXX) $(CXXFLAGS) -c $< -o $@
else
	@echo "Compiling $<..."
	@$(CXX) $(CXXFLAGS) -c $< -o $@
endif

# Clean build files
clean:
	rm -f $(OBJECTS) $(PROGRAM)

# Install vcpkg dependencies
install-vcpkg-deps:
	@echo "Installing dependencies via vcpkg..."
	@if [ -z "$(VCPKG_ROOT)" ]; then \
		echo "Error: VCPKG_ROOT environment variable is not set."; \
		echo "Please install vcpkg and set VCPKG_ROOT to the vcpkg directory."; \
		echo "See: https://github.com/Microsoft/vcpkg"; \
		exit 1; \
	fi
	cd $(VCPKG_ROOT) && ./vcpkg install wxwidgets:$(VCPKG_TRIPLET)

# Install dependencies (requires Homebrew)
install-deps:
	@echo "Installing dependencies via Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Error: Homebrew is not installed. Please install it first from https://brew.sh/"; \
		exit 1; \
	fi
	brew install wxwidgets

# Check if wxWidgets is properly installed
check-wx:
	@echo "Checking wxWidgets installation..."
	@if command -v wx-config >/dev/null 2>&1; then \
		echo "✓ wx-config found: `which wx-config`"; \
		echo "✓ wxWidgets version: `wx-config --version`"; \
		echo "✓ wxWidgets libs: `wx-config --libs`"; \
	else \
		echo "✗ wx-config not found. Please install wxWidgets first with 'make install-deps'"; \
		exit 1; \
	fi

# Run the program
run: $(PROGRAM)
	./$(PROGRAM)

# Help
help:
	@echo "Available targets:"
	@echo "  all              - Build the program (default)"
	@echo "  debug            - Build with debug symbols"
	@echo "  verbose          - Build with verbose output"
	@echo "  clean            - Remove build files"
	@echo "  install-vcpkg-deps - Install wxWidgets via vcpkg"
	@echo "  install-deps     - Install wxWidgets via Homebrew"
	@echo "  check-wx         - Check if wxWidgets is properly installed"
	@echo "  run              - Build and run the program"
	@echo "  help             - Show this help"
	@echo ""
	@echo "Build system: g++ with Makefile (no CMake)"
	@echo "C++ Standard: C++17"
	@echo ""
	@echo "vcpkg usage:"
	@echo "  1. Install vcpkg: git clone https://github.com/Microsoft/vcpkg.git"
	@echo "  2. Bootstrap vcpkg: cd vcpkg && ./bootstrap-vcpkg.sh"
	@echo "  3. Set environment: export VCPKG_ROOT=/path/to/vcpkg"
	@echo "  4. Install deps: make install-vcpkg-deps"
	@echo "  5. Build: make"

.PHONY: all debug verbose clean install-vcpkg-deps install-deps check-wx run help
