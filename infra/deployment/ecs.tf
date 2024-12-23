resource "aws_ecs_cluster" "my_cluster" {
  name = "${var.namespace}-${var.env}-my-cluster"
}

# Task: A single execution of a task definition, comprising one or more containers.
resource "aws_ecs_task_definition" "my_api_task" {
  family                   = "${var.namespace}-${var.env}-my-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256   # 0.25 vCPU
  memory                   = 512   # 512 MB of memory

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = "${var.ecr_repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.host_port
    }]
  }])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn # ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  task_role_arn      = aws_iam_role.ecs_task_execution.arn # ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services.
}

# Service: A logical unit that manages and scales a group of tasks based on the same task definition.
#          Defines how many instances of the task_definition we want to run, we provide this with the desired_count attribute. Each instance of a task_definition is called a Task.
# aws_ecs_service: provides an ECS service - effectively a task that is expected to run until an error occurs or a user terminates it (typically a webserver or a database).
resource "aws_ecs_service" "api" {
  name            = "${var.namespace}-${var.env}-my-api"
  cluster         = aws_ecs_cluster.my_cluster.name
  launch_type     = "FARGATE"
  desired_count   = length(module.network.subnets_id)
  task_definition = aws_ecs_task_definition.my_api_task.arn

  network_configuration {
    subnets          = module.network.subnets_id
    security_groups  = [module.network.security_group_ecs_id]
    assign_public_ip = var.subnets_public # Needs to be set to true if wanting to comunicate with the internet, this is becasue we are using Fargate
  }
  load_balancer {
    target_group_arn = module.network.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [ module.network.lb_listener ]
}