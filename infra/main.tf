
terraform {
  required_version = ">= 1.9.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


locals{
  region    = "eu-north-1"
  namespace = "my-fastapi-app"
  env       = "uat"
}


provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Environment = local.env
      Project     = local.namespace
      Name        = local.namespace
    }
  }
  
}

module "setup" {
  source    = "./setup"
  namespace = local.namespace
  env       = local.env
}

module "deployment" {
  source             = "./deployment"
  namespace          = local.namespace
  env                = local.env
  az_count           = 3
  ecr_repository_url = module.setup.ecr_repository_url
  subnets_public     = true
}