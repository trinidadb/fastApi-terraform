
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
 default_tags {
   tags = {
     Environment = "Test"
     Project     = "Test"
     Name        = "Test"
   }
 }
  
}

module "setup" {
  source = "./setup"
  namespace = var.namespace
}

module "deployment" {
  source = "./deployment"
  namespace = var.namespace
  ecr_repository_url = module.setup.ecr_repository_url
}
