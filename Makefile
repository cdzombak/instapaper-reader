SHELL:=/usr/bin/env bash
default: help

VERSION=0.0.1

# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build dependencies are installed
	@command -v nativefier >/dev/null 2>&1 || echo "[!] Missing nativefier: npm install -g nativefier"

.PHONY: clean-mac
clean-mac:  ## Clean mac build directory
	rm -rf ./mac

.PHONY: build-mac
build-mac: clean-mac check-deps  ## Build app for macOS/x64
	mkdir ./mac
	nativefier \
	"https://instapaper.com/u" \
		-p mac \
		-a x64 \
		-n "Instapaper Reader" \
		-i ./instapaper_app_logo.icns \
		--internal-urls "^https:\\/\\/(www\\.)?instapaper.com\\/?.*" \
		--disable-dev-tools \
		--min-width 375 \
		--min-height 600 \
		--width 850 \
		--height 1050 \
		--fast-quit \
		--darwin-dark-mode-support \
		--app-version ${VERSION} \
		./mac

.PHONY: install-mac
install-mac: build-mac  ## Build & install to /Applications on macOS
	cp -R "./mac/Instapaper Reader-darwin-x64/Instapaper Reader.app" /Applications
