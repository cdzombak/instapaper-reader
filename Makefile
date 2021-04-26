SHELL:=/usr/bin/env bash

VERSION=1.0.0
IP_URL="https://instapaper.com/u"
define BUILD_FLAGS
-n "Instapaper Reader" \
--internal-urls "^https:\\/\\/(www\\.)?instapaper.com\\/?.*" \
--disable-dev-tools \
--min-width 375 \
--min-height 600 \
--width 850 \
--height 1050 \
--app-version ${VERSION} \
-i ./instapaper_app_logo.icns \
--fast-quit \
--darwin-dark-mode-support
endef

default: help
# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build dependencies are installed
	@command -v nativefier >/dev/null 2>&1 || echo "[!] Missing nativefier: npm install -g nativefier"

.PHONY: clean
clean:  ## Clean build output directory
	rm -rf ./out

.PHONY: build
build: clean check-deps  ## Build app for the current platform
	mkdir ./out
	nativefier ${IP_URL} ${BUILD_FLAGS} ./out

.PHONY: install-mac
install-mac: build  ## Build & install to /Applications (for macOS)
	cp -R "./out/Instapaper Reader-darwin-x64/Instapaper Reader.app" /Applications || cp -R "./out/Instapaper Reader-darwin-arm64/Instapaper Reader.app" /Applications
