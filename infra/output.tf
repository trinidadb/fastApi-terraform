output "ecr_repository_url" {
  value = module.setup.ecr_repository_url
}

output "task_arn" {
  value = module.deployment.task_arn
}

output "vpc_id" {
  value = module.deployment.vpc_id
}

output "subnets_id" {
  value = module.deployment.subnets_id
}

output "lb_target_group_arn" {
  value = module.deployment.lb_target_group_arn
}

output "lb_listener" {
  value = module.deployment.lb_listener
}

output "security_group_ecs_id" {
  value = module.deployment.security_group_ecs_id
}

output "alb_dns_name" {
  value = module.deployment.alb_dns_name
}