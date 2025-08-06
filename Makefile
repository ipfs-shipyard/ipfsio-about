# Makefile for developing website (cross-platform)

HUGO_VERSION := 0.124.1

# Detect OS and architecture
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Set OS-specific variables
ifeq ($(UNAME_S),Linux)
	OS := Linux
	ARCH := 64bit
	ARCHIVE_EXT := tar.gz
	BINARY_EXT := 
endif
ifeq ($(UNAME_S),Darwin)
	OS := macOS
	ARCH := 64bit
	ARCHIVE_EXT := tar.gz
	BINARY_EXT := 
endif
ifeq ($(OS),Windows_NT)
	OS := Windows
	ARCH := 64bit
	ARCHIVE_EXT := zip
	BINARY_EXT := .exe
endif

# Handle different architectures
ifeq ($(UNAME_M),arm64)
	ARCH := ARM64
endif
ifeq ($(UNAME_M),aarch64)
	ARCH := ARM64
endif

HUGO_BINARY := .tmp/hugo$(BINARY_EXT)
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(OS)-$(ARCH).$(ARCHIVE_EXT)

# Default target
.PHONY: build
build: hugo-check
	$(HUGO_BINARY) --minify

# Development server
.PHONY: serve
serve: hugo-check
	$(HUGO_BINARY) server --disableFastRender

# Clean generated files
.PHONY: clean
clean:
	rm -rf public/ resources/

# Check if Hugo is available, download if missing
.PHONY: hugo-check
hugo-check:
	@if ! test -f $(HUGO_BINARY); then \
		echo "Hugo not found at $(HUGO_BINARY), downloading Hugo $(HUGO_VERSION) extended..."; \
		$(MAKE) download-hugo; \
	else \
		HUGO_VER=$$($(HUGO_BINARY) version | grep -o 'v[0-9.]*' | head -1 | sed 's/v//'); \
		if test "$$HUGO_VER" != "$(HUGO_VERSION)"; then \
			echo "Hugo version $$HUGO_VER found, but $(HUGO_VERSION) required. Downloading..."; \
			$(MAKE) download-hugo; \
		else \
			echo "Hugo $(HUGO_VERSION) found at $(HUGO_BINARY)"; \
		fi \
	fi

# Download and install Hugo extended
.PHONY: download-hugo
download-hugo:
	@echo "Downloading Hugo $(HUGO_VERSION) extended for $(OS)-$(ARCH)..."
	@mkdir -p .tmp
ifeq ($(ARCHIVE_EXT),zip)
	@curl -sL $(HUGO_URL) -o .tmp/hugo.zip
	@cd .tmp && unzip -q hugo.zip
	@rm -f .tmp/hugo.zip .tmp/LICENSE .tmp/README.md
else
	@curl -sL $(HUGO_URL) -o .tmp/hugo.tar.gz
	@tar -xzf .tmp/hugo.tar.gz -C .tmp
	@rm -f .tmp/hugo.tar.gz .tmp/LICENSE .tmp/README.md
endif
	@chmod +x $(HUGO_BINARY)
	@echo "Hugo $(HUGO_VERSION) extended installed to $(HUGO_BINARY)"

# Help target
.PHONY: help
help:
	@echo "Cross-platform Hugo website build system"
	@echo "Detected platform: $(OS)-$(ARCH)"
	@echo ""
	@echo "Available targets:"
	@echo "  build       - Build the website (default)"
	@echo "  serve       - Start development server"
	@echo "  clean       - Clean generated files"
	@echo "  hugo-check  - Check/install Hugo $(HUGO_VERSION) extended"
	@echo "  help        - Show this help"
	@echo ""
	@echo "Supported platforms: Linux, macOS, Windows (x86_64/ARM64)"
