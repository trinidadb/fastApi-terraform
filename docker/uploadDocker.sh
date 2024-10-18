#!/bin/bash
TAG="latest"

# Full ECR_URL passed asfirst argument
ECR_URL=$1

# Extract the ACCOUNT_ID, AWS_REGION, and REGISTRY_NAME as: ECR_URL="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REGISTRY_NAME"
ACCOUNT_ID=$(echo $ECR_URL | cut -d'.' -f1)
AWS_REGION=$(echo $ECR_URL | cut -d'.' -f4)
REGISTRY_NAME=$(echo $ECR_URL | cut -d'/' -f2)

echo "Logging in to ECR"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Building image"
docker build --no-cache --platform=linux/amd64 -t $REGISTRY_NAME .

echo "Tagging image"
docker tag $REGISTRY_NAME:$TAG $ECR_URL:$TAG

echo "Pushing image to ECR"
docker push $ECR_URL:$TAG