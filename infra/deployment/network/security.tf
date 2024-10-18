# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "alb" {
    name        = "${var.namespace}-${var.env}-lb-security-group"
    description = "Controls access to the ALB"
    vpc_id      = aws_vpc.my-vpc.id

    # Allows inbound traffic on the port specified by the variable var.app_port from any IP address (0.0.0.0/0), meaning it's open to the internet.
    ingress { #HTTP
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { #False HTTPs as there is no associated certificate
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allows all outbound traffic from "all protocols" (e.g., TCP, UDP, ICMP)(protocol = "-1") on any port
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs_tasks" {
    name        = "${var.namespace}-${var.env}-ecs-security-group"
    description = "Allows inbound access from the ALB only"
    vpc_id      = aws_vpc.my-vpc.id

    # Traffic to the ECS cluster should only come from the ALB
    ingress {
        protocol        = "tcp"
        from_port       = var.container_port
        to_port         = var.container_port
        security_groups = [aws_security_group.alb.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

####################### ALLOW ALL VPC ##########################

# resource "aws_security_group" "allow-all" {
#   name   = "ecs-security-group"
#   vpc_id = aws_vpc.my-vpc.id
#   tags = {
#     Name = "allow all"
#  }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow-all-ipv4" {
#   security_group_id = aws_security_group.allow-all.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # -1 to specify all protocols. Note that if ip_protocol is set to -1, 
#                            # it translates to all protocols, all port ranges, and from_port and to_port values should not be defined.
#                            # Represents "all protocols" (e.g., TCP, UDP, ICMP). Essentially, it allows all traffic types.
# }

# resource "aws_vpc_security_group_egress_rule" "allow-all-ipv4" {
#   security_group_id = aws_security_group.allow-all.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # -1 to specify all protocols. Note that if ip_protocol is set to -1, 
#                            # it translates to all protocols, all port ranges, and from_port and to_port values should not be defined.
#                            # Represents "all protocols" (e.g., TCP, UDP, ICMP). Essentially, it allows all traffic types.
# }

# resource "aws_vpc_security_group_ingress_rule" "allow-all-ipv6" {
#   security_group_id = aws_security_group.allow-all.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # -1 to specify all protocols. Note that if ip_protocol is set to -1, 
#                            # it translates to all protocols, all port ranges, and from_port and to_port values should not be defined.
#                            # Represents "all protocols" (e.g., TCP, UDP, ICMP). Essentially, it allows all traffic types.
# }

# resource "aws_vpc_security_group_egress_rule" "allow-all-ipv6" {
#   security_group_id = aws_security_group.allow-all.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # -1 to specify all protocols. Note that if ip_protocol is set to -1, 
#                            # it translates to all protocols, all port ranges, and from_port and to_port values should not be defined.
#                            # Represents "all protocols" (e.g., TCP, UDP, ICMP). Essentially, it allows all traffic types.
# }