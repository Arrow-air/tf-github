## DO NOT EDIT!
# This file was provisioned by Terraform
# File origin: https://github.com/Arrow-air/tf-github/tree/main/src/templates/nuxt-all/Makefile

DOCKER_NAME := arrow-${name}

help: .help-base .help-cspell .help-markdown .help-editorconfig .help-commitlint

include .make/base.mk
include .make/cspell.mk
include .make/markdown.mk
include .make/editorconfig.mk
include .make/commitlint.mk

test: cspell-test md-test-links editorconfig-test
