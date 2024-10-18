
# include .env 
# .EXPORT_ALL_VARIABLES:
# # Check if AWS_ACCOUNT_ID is already set in the .env file
# AWS_ACCOUNT_ID := $(if $(AWS_ACCOUNT_ID),$(AWS_ACCOUNT_ID),$(shell aws sts get-caller-identity --query Account --output text))

setup-ecr: 
	cd infra && terraform init && terraform apply -target="module.setup" -auto-approve

deploy-container:
	$(eval ECR_URL=$(shell cd infra && terraform output -raw ecr_repository_url))
	cd docker && sh uploadDocker.sh $(ECR_URL)

deploy-service:
	cd infra && terraform init && terraform apply -target="module.deployment" -auto-approve

destroy-service:
	cd infra && terraform init && terraform destroy -auto-approve

complete-deployment: 
	$(MAKE) setup-ecr
	$(MAKE) deploy-container
	$(MAKE) deploy-service