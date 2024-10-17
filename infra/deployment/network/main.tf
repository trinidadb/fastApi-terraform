# https://www.oneworldcoders.com/blog/part-2-networking-and-load-balancer-configuration-scaling-an-app-using-awss-ecs-with-tf


# To check DNS parameters: https://medium.com/@mrdevsecops/dns-resolution-in-vpc-e2fc2e3c0d3a
resource "aws_vpc" "my-vpc" {
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true 
 enable_dns_support = true
}

resource "aws_subnet" "my-subnets" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = var.subnets_public
  cidr_block              = cidrsubnet(aws_vpc.my-vpc.cidr_block, 8, count.index+1) #Subnets 10.0.1.0/24 and  10.0.2.0/24 if az_count=2
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}

#To check for AZ in a region: aws ec2 describe-availability-zones --region eu-north-1
# resource "aws_subnet" "subnet-1" {
#  vpc_id                  = aws_vpc.my-vpc.id
#  cidr_block              = cidrsubnet(aws_vpc.my-vpc.cidr_block, 8, 1) #Subnet 10.0.1.0/24
#  map_public_ip_on_launch = var.subnets_public
#  availability_zone       = "${var.region}a"
# }

# resource "aws_subnet" "subnet-2" {
#  vpc_id                  = aws_vpc.my-vpc.id
#  cidr_block              = cidrsubnet(aws_vpc.my-vpc.cidr_block, 8, 2) #Subnet 10.0.2.0/24
#  map_public_ip_on_launch = var.subnets_public
#  availability_zone       = "${var.region}b"
# }
