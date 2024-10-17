#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="eu-north-1"
AWS_ENV="uat"
NAMESPACE="my-app"
REGISTRY_NAME="$NAMESPACE-$AWS_ENV"
ECR_URL="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REGISTRY_NAME"
TAG="latest"

echo "Logging in to ECR"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Building image"
docker build --no-cache --platform=linux/amd64 -t $REGISTRY_NAME .

echo "Tagging image"
docker tag $REGISTRY_NAME:$TAG $ECR_URL:$TAG

echo "Pushing image to ECR"
docker push $ECR_URL:$TAG