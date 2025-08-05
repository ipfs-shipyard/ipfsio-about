# Makefile for developing website on linux

HUGO_VERSION := 0.124.1
HUGO_BINARY := .tmp/hugo
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_Linux-64bit.tar.gz

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
	@if [ ! -f $(HUGO_BINARY) ]; then \
		echo "Hugo not found at $(HUGO_BINARY), downloading Hugo $(HUGO_VERSION) extended..."; \
		$(MAKE) download-hugo; \
	else \
		HUGO_VER=$$($(HUGO_BINARY) version | grep -o 'v[0-9.]*' | head -1 | sed 's/v//'); \
		if [ "$$HUGO_VER" != "$(HUGO_VERSION)" ]; then \
			echo "Hugo version $$HUGO_VER found, but $(HUGO_VERSION) required. Downloading..."; \
			$(MAKE) download-hugo; \
		else \
			echo "Hugo $(HUGO_VERSION) found at $(HUGO_BINARY)"; \
		fi \
	fi

# Download and install Hugo extended
.PHONY: download-hugo
download-hugo:
	@echo "Downloading Hugo $(HUGO_VERSION) extended..."
	@mkdir -p .tmp
	@curl -sL $(HUGO_URL) -o .tmp/hugo.tar.gz
	@tar -xzf .tmp/hugo.tar.gz -C .tmp
	@chmod +x $(HUGO_BINARY)
	@rm -f .tmp/hugo.tar.gz .tmp/LICENSE .tmp/README.md
	@echo "Hugo $(HUGO_VERSION) extended installed to $(HUGO_BINARY)"

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build       - Build the website (default)"
	@echo "  serve       - Start development server"
	@echo "  clean       - Clean generated files"
	@echo "  hugo-check  - Check/install Hugo"
	@echo "  help        - Show this help"
