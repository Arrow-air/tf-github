## DO NOT EDIT!
# This file was provisioned by Terraform
# File origin: https://github.com/Arrow-air/tf-github/tree/main/src/templates/all/.make/terraform.mk

TF_IMAGE_NAME ?= hashicorp/terraform
TF_IMAGE_TAG  ?= latest

# function with a generic template to run docker with the required values
# Accepts $1 = command to run, $2 = additional command flags (optional)
tf_run = docker run \
	--name=$(DOCKER_NAME)-$@ \
	--workdir=/opt/ \
	--rm \
	--user `id -u`:`id -g` \
	-v "$(SOURCE_PATH)/src/:/opt/" \
	-v "$(HOME)/.terraform.d:/opt/.terraform.d" \
	-e "TF_CLI_CONFIG_FILE=/opt/.terraform.d/credentials.tfrc.json" \
	-e "TF_IN_AUTOMATION=true" \
	-e "TF_WORKSPACE=$(TF_WORKSPACE)" \
	-t $(TF_IMAGE_NAME):$(TF_IMAGE_TAG) \
	$(1) $(2)

tf-docker-pull:
	@echo docker pull -q $(TF_IMAGE_NAME):$(TF_IMAGE_TAG)

.help-tf:
	@echo ""
	@echo "$(SMUL)$(BOLD)$(GREEN)Terraform$(SGR0)"
	@echo "  $(BOLD)tf-clean$(SGR0)       -- Run 'rm -rf src/.terraform'"
	@echo "  $(BOLD)tf-init-ARG$(SGR0)    -- Run 'TF_WORKSPACE=ARG terraform init'"
	@echo "  $(BOLD)tf-plan-ARG$(SGR0)    -- Run 'TF_WORKSPACE=ARG terraform plan'"
	@echo "  $(BOLD)tf-fmt$(SGR0)         -- Run 'terraform fmt -check -recursive' to check terraform file formats."
	@echo "  $(BOLD)tf-tidy$(SGR0)        -- Run 'terraform fmt -recursive' to fix terraform file formats if needed."
	@echo "  $(CYAN)Combined targets$(SGR0)"
	@echo "  $(BOLD)tf-all$(SGR0)         -- Run targets; tf-clean tf-test"

.SILENT: tf-docker-pull

tf-clean: tf-docker-pull
	@echo "$(CYAN)Removing .terraform directory...$(SGR0)"
	@rm -rf ./src/.terraform

tf-init-%: TF_WORKSPACE=$*
tf-init-%: tf-docker-pull
	@echo "$(CYAN)Running terraform init...$(SGR0)"
	@$(call tf_run,init)

tf-plan-%: TF_WORKSPACE=$*
tf-plan-%: tf-docker-pull
	@echo "$(CYAN)Running terraform plan...$(SGR0)"
	@$(call tf_run,plan)

tf-fmt: tf-docker-pull
	@echo "$(CYAN)Running and checking terraform file formats...$(SGR0)"
	@$(call tf_run,fmt,-check -recursive)

tf-tidy: tf-docker-pull
	@echo "$(CYAN)Running terraform file formatting fixes...$(SGR0)"
	@$(call tf_run,fmt,-recursive)

tf-all: tf-clean tf-test
