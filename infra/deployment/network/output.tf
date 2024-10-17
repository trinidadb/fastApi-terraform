output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "subnets_id" {
  value = aws_subnet.my-subnets.*.id
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.service_target_group.arn
}

output "lb_listener" {
  value = aws_lb_listener.my-listener.id
}

output "security_group_ecs_id" {
  value = aws_security_group.ecs_tasks.id
}

output "alb_dns_name" {
  value = aws_lb.my-alb.dns_name
}