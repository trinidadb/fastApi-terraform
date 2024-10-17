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
# If your ECS tasks need to communicate with other AWS services (e.g., S3, DynamoDB, etc.), use a NAT Gateway in a public subnet 
# to enable outbound traffic to the internet, without exposing the tasks to incoming traffic from the internet.