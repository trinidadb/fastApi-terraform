output "task_arn" {
  value = aws_ecs_task_definition.my_api_task.arn
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnets_id" {
  value = module.network.subnets_id
}

output "lb_target_group_arn" {
  value = module.network.lb_target_group_arn
}

output "lb_listener" {
  value = module.network.lb_listener
}

output "security_group_ecs_id" {
  value = module.network.security_group_ecs_id
}

output "alb_dns_name" {
  value = module.network.alb_dns_name
}