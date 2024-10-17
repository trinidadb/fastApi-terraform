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