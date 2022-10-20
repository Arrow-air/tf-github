DOCKER_NAME = arrow-benchmarks

help: .help-base .help-cspell .help-markdown .help-editorconfig .help-toml .help-python
	@echo "$(MAKEFILE_LIST)"
	@echo "$(SMUL)$(BOLD)$(GREEN)Rust$(NC)$(SGR0)"
	@echo "  $(YELLOW)All cargo commands will use '--manifest-path $(CARGO_MANIFEST_PATH)'$(SGR0)"
	@echo "  $(BOLD)build$(SGR0)       -- Run 'cargo build'"
	@echo "  $(BOLD)rust-check$(SGR0)  -- Run 'cargo check'"
	@echo "  $(BOLD)rust-test$(SGR0)   -- Run 'cargo test --all'"
	@echo "  $(BOLD)rust-clippy$(SGR0) -- Run 'cargo clippy --all -- -D warnings'"
	@echo "  $(BOLD)rust-fmt$(SGR0)    -- Run 'cargo fmt --all -- --check' to check rust file formats."
	@echo "  $(BOLD)rust-tidy$(SGR0)   -- Run 'cargo fmt --all' to fix rust file formats if needed."

include .make/base.mk
include .make/cspell.mk
include .make/markdown.mk
include .make/editorconfig.mk
include .make/toml.mk
include .make/python.mk

# function with a generic template to run docker with the required values
# Accepts $1 = command to run, $2 = additional flags (optional)
docker_run = docker run \
	--name=$(DOCKER_NAME)-$@ \
	--rm \
	--user $(id -u):$(id -g) \
	-v "$(PWD):/usr/src/app" \
	$(2) \
	-t $(RUST_IMAGE_NAME):$(RUST_IMAGE_TAG) \
	$(1)

SOURCE_PATH=$(PWD)/server-web
PYTHON_PATH=server-web/

build:
	cd ./server-web && $(MAKE) $@
rust-%:
	cd ./server-web && $(MAKE) $@
python-%:
	cd ./server-web && $(MAKE) $@

test: rust-test-all cspell-test toml-test python-test md-test-links editorconfig-test
