variable "region" {
  type        = string
  default     = "eu-north-1"
  description = "What AWS region to deploy resources in."
}

variable "env" {
  type        = string
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
  default     = "uat"
}

variable "namespace" {
  type        = string
  description = "namespace, which is the name of the app"
  default     = "my-app"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    type = number
    default = 2
}

variable "container_name" {
    description = "Name of the container to deploy"
    type        = string
    default     = "my-container"
}

variable "container_port" {
    description = "Port that your container (ECS task) is listening on. This is where your application or API will be running inside the container"
    type        = number
    default     = 8000
}

variable "host_port" {
    description = "For AWS Fargate, hostPort and containerPort should generally be the same, since Fargate abstracts away the underlying host"
    type        = number
    default     = 8000
}

variable "app_port" {
    description = "Port that listens for incoming traffic from the user or client "
    type        = number
    default     = 80
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL for the container image"
}

variable "subnets_public" {
  description = "Determines if public ids are map to vpc subnets on launch. AWS charges for using public ids"
  type = bool
  default = true
}