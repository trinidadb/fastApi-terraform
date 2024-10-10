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
  description = "namespace, which could be your organization name, e.g. amazon"
  default     = "GlobalExchange"
}

variable "dockersLoc" {
  type        = string
  description = "Path to dockers general directory relative to the location of the terraform code"
  default     = "../dockers"
}

variable "dockerDir" {
  type        = string
  description = "Docker directory where dockerfile is found"
  default     = ".docker"
}

variable "cronExpression" {
  type        = string
  description = "Cron expression to define the time of the event scheduler"
  default     = "cron(0 0 * * ? *)"
}

variable "timezone" {
  type        = string
  description = "Timezone of the event scheduler"
  default     = "Europe/Madrid"
}

variable "lambdaTimeout" {
  type        = number
  description = "Timout of the lambda"
  default     = 3
}

variable "lambdaMemory" {
  type        = number
  description = "Memory size of the lambda"
  default     = 512
}