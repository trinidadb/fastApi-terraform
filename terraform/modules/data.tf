# Use this data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized.
data "aws_caller_identity" "current_user" {}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_role_scheduler" {
  statement {
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
