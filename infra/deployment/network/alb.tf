resource "aws_lb" "my-alb" {
    name        = "${var.namespace}-${var.env}-lb"
    subnets         = aws_subnet.my-subnets.*.id # Reference all count objects. Specifies the public subnets in which the ALB is deployed
    security_groups = [aws_security_group.alb.id]
}

# Defines the target group that the ALB will forward traffic to. The target group contains the backend services (e.g., ECS tasks) that process the requests forwarded by the ALB.
resource "aws_lb_target_group" "service_target_group" {
    name        = "${var.namespace}-${var.env}-lb-target-group"
    port        = var.container_port # Port on which the backend services (ECS tasks) are listening. Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb
    protocol    = "HTTP"             # Protocol to use for routing traffic to the targets (forward traffic from the ALB to the targets )
    vpc_id      = aws_vpc.my-vpc.id  # Identifier of the VPC in which to create the target group.
    target_type = "ip"               # The ALB will route traffic directly to IP addresses of the targets (usually ECS tasks). This is different from target_type = "instance", where the ALB would forward traffic to the EC2 instances directly
                                     # The ALB routes traffic to IP addresses of the targets. This is often used with AWS Fargate (serverless ECS) or containerized workloads where the individual containers or tasks have private IP addresses.
                                     # If you're using ECS or Fargate to manage containers, the ALB routes traffic to individual containers (ECS tasks), which are assigned their own private IP addresses. In this case, the target_type = "ip" is used to route traffic to those private IPs.
                                     # If you're using EC2 instances directly (e.g., running your app on EC2 without containers), you might set target_type = "instance".

    health_check { # Defines how the ALB checks if the targets are healthy
        enabled             = true
        protocol            = "HTTP"
        matcher             = "200"
        path                = "/health"
        unhealthy_threshold = 2
        healthy_threshold   = 3
        interval            = 30
        timeout             = 3
    }
}

# A listener checks for incoming requests on a specific port and forwards them to the appropriate target group.
# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "my-listener" {
  load_balancer_arn = aws_lb.my-alb.id   # The ARN of the ALB (aws_alb.main.id) that this listener is attached to.
  port              = var.app_port       # The port on which the ALB listens for incoming traffic.
  protocol          = "HTTP"             # The protocol for the listener

  default_action {
    target_group_arn = aws_lb_target_group.service_target_group.id   # The ARN of the target group that the listener forwards traffic to
    type             = "forward"
  }
}


############### SUMMARY ################
/*
1) Client Request: A user accesses your application by hitting the ALB's public IP or domain name (e.g., through Route 53). The ALB listens for incoming traffic on a specified port (e.g., 80 or 443).

2) ALB Listener: The listener on the ALB (defined in aws_alb_listener.front_end) processes the incoming request and forwards it to the target group (aws_alb_target_group.app).

3) Target Group: The ALB sends the traffic to the targets (ECS tasks or other services), which are members of the target group.

4) Health Check: The ALB continuously monitors the health of the targets using the health check configuration. Only healthy targets receive traffic.
*/