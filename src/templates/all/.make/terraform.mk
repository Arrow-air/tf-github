## DO NOT EDIT!
# This file was provisioned by Terraform
# File origin: https://github.com/Arrow-air/tf-github/tree/main/src/templates/all/.make/terraform.mk

JQ                             := $(shell command -v jq 2> /dev/null)
TF_STATE_FILE                  := $(SOURCE_PATH)/src/.terraform/terraform.tfstate
TF_IMAGE_NAME                  ?= ghcr.io/arrow-air/tools/arrow-tfenv
TF_IMAGE_TAG                   ?= 3.0.0-v1.4.2
TF_WORKSPACE                   ?= default
GOOGLE_APPLICATION_CREDENTIALS ?= $(HOME)/.config/gcloud/application_default_credentials.json

TF_STATE_BUCKET = $(TF_PREFIX)-$(*)-$(TF_PROJECT)-tfstate

# function with a generic template to run docker with the required values
# Accepts $1 = command to run, $2 = additional command flags (optional)
tf_run = docker run \
	--name=${DOCKER_NAME}-$@ \
	--workdir=/opt/ \
	--rm \
	--user `id -u`:`id -g` \
	-v "${SOURCE_PATH}/src/:/opt/" \
	-v "${GOOGLE_APPLICATION_CREDENTIALS}:/opt/credentials.json" \
	-e "GOOGLE_APPLICATION_CREDENTIALS=/opt/credentials.json" \
	-e "GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=tf-${TF_WORKSPACE}-${TF_PROJECT}@${TF_PREFIX}-${TF_WORKSPACE}-${TF_PROJECT}.iam.gserviceaccount.com" \
	-e "PLAN_FILE=plan-${TF_WORKSPACE}.tfplan" \
	-e "TF_IN_AUTOMATION=true" \
	-e "TF_WORKSPACE=${TF_WORKSPACE}" \
	-e "TF_STATE_BUCKET=${TF_PREFIX}-${TF_WORKSPACE}-${TF_PROJECT}-tfstate" \
	-e "TF_VAR_tf_project=${TF_PROJECT}" \
	-t ${TF_IMAGE_NAME}:${TF_IMAGE_TAG} \
	$(1) $(2)

# function to call init and providing a reason why init is needed
define call_init
	echo "$(1)"
	$(call tf_run,init,-backend-config="bucket=$(TF_STATE_BUCKET)" -upgrade)
endef

# Check if we need to run init, call_init when needed
ifeq ("$(wildcard $(TF_STATE_FILE))", "")
define check_init
	$(call run_init, "No state file found, need init")
endef
else
	ifdef JQ
define check_init
	CONFIGURED_STATE_BUCKET=$(shell jq -r '.backend.config.bucket' < ${TF_STATE_FILE})
	CONFIGURED_BACKEND_TYPE=$(shell jq -r '.backend.type' < ${TF_STATE_FILE})
	$(if $(findstring,"$(CONFIGURED_BACKEND_TYPE)","local"),$(call run_init,"State file $(CONFIGURED_BACKEND_TYPE) always run init"),$(if $(findstring,"$(CONFIGURED_STATE_BUCKET)","$(TF_STATE_BUCKET)"),0,$(call run_init,"Backend bucket mismatch in jq test (\"$(CONFIGURED_STATE_BUCKET)\" != \"$(TF_STATE_BUCKET)\")\ need to run init")))
endef
	else
define check_init
	$(if $(shell grep bucket "${TF_STATE_FILE}" | grep -q -- ${TF_STATE_BUCKET} && echo $?) != 0,$(call run_init,"Backend bucket mismatch in grep test"))
endef
	endif
endif

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

tf-validate-%: TF_WORKSPACE=$*
tf-validate-%: tf-docker-pull
	@$(call check_init)
	@echo "$(CYAN)Running terraform validate...$(SGR0)"
	@$(call tf_run,validate)

tf-init-%: TF_WORKSPACE=$*
tf-init-%: tf-docker-pull
	@echo "$(CYAN)Running terraform init...$(SGR0)"
	@$(call tf_run,init,-backend-config="bucket=$(TF_STATE_BUCKET)" -upgrade)

tf-plan-%: TF_WORKSPACE=$*
tf-plan-%: tf-docker-pull
	@$(call check_init)
	@echo "$(CYAN)Running terraform plan...$(SGR0)"
	@$(call tf_run,plan)

tf-fmt: tf-docker-pull
	@echo "$(CYAN)Running and checking terraform file formats...$(SGR0)"
	@$(call tf_run,fmt,-check -recursive)

tf-tidy: tf-docker-pull
	@echo "$(CYAN)Running terraform file formatting fixes...$(SGR0)"
	@$(call tf_run,fmt,-recursive)

tf-all: tf-clean tf-test
