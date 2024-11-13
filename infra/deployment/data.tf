# Use this data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized.
# data "aws_caller_identity" "current_user" {}

data "aws_iam_policy_document" "assume_role_ecs_tasks" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}