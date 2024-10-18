variable "env" {
  type        = string
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
}

variable "namespace" {
  type        = string
  description = "namespace, which is the name of the app"
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    type = number
}

variable "subnets_public" {
  description = "Determines if public ids are map to vpc subnets on launch. AWS charges for using public ids. It is used also to determine  the value of aasign_pulic_ip in the network_configuration in aws_ecs_service."
                # For tasks in public subnets and using FARGATE, specify ENABLED for Auto-assign public IP when launching the task. https://docs.aws.amazon.com/AmazonECS/latest/developerguide/verify-connectivity.html
  type = bool
}


variable "container_port" {
    description = "Port that your container (ECS task) is listening on. This is where your application or API will be running inside the container"
    type        = number
    default = 8000
}


variable "app_port" {
    description = "Port that listens for incoming traffic from the user or client "
    type        = number
    default     = 8000
}

