include .env 

.EXPORT_ALL_VARIABLES:

# Check if AWS_ACCOUNT_ID is already set in the .env file
AWS_ACCOUNT_ID := $(if $(AWS_ACCOUNT_ID),$(AWS_ACCOUNT_ID),$(shell aws sts get-caller-identity --query Account --output text))
NAMESPACE=my-app-name
ENV=uat

# TAG=latest
# TF_VAR_app_name=${APP_NAME}
# REGISTRY_NAME=${APP_NAME}-${ENV}
# TF_VAR_image=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REGISTRY_NAME}:${TAG}
# TF_VAR_region=${AWS_REGION}


setup-ecr: 
	cd infra && terraform init && terraform apply -target="module.setup" -auto-approve

deploy-container:
	cd docker && sh uploadDocker.sh

deploy-service:
	cd infra && terraform init && terraform apply -target="module.deployment" -auto-approve

destroy-service:
	cd infra && terraform init && terraform destroy -auto-approve

complete-deployment: 
	setup-ecr deploy-container deploy-service