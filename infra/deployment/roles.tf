
# This part creates the IAM role that ECS tasks will use for execution. The assume_role_policy refers to the previously defined IAM policy (ecs_assume_policy) which allows the ECS service to assume the role. 
resource "aws_iam_role" "ecs_task_execution" {
  name               = "ecs-task-execution-${var.namespace}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs_tasks.json
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name = "ecs-execution-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "ecr:*",
          "ecs:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "logs:*"
        ],
        Resource : "*"
      }
    ]
  })
}

# This attachment ensures that the ECS task inherits the necessary permissions to interact with other AWS services.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

/*
The overall goal of this Terraform code is to set up an ECS execution role with necessary permissions. The role allows ECS tasks to:

Assume the role via sts:AssumeRole.
Pull container images from ECR.
Communicate with ECS.
Interact with Load Balancers, CloudWatch, and Logs.

*/