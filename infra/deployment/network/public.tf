# Conditionally create an Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  count  = var.subnets_public ? 1 : 0  # Create resource only if "var.subnets_public" is true
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "route_table" {
  # Terraform does detect dependencies between resources based on references like gateway_id = aws_internet_gateway.my-igw.id.
  # However, Terraform does not automatically manage conditional creation of resources. 
  count  = var.subnets_public ? 1 : 0 
  vpc_id = aws_vpc.my-vpc.id

  #0.0.0.0/0 is the default route that matches all IP addresses. All the traffic will be sent to the IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw[0].id # When using count, you must use an index to refer to the created resource (even if there is only one).
  }
  tags = {
     Name = "public-route-table"
   }
}

# Route Table Sharing: If multiple subnets are associated with the same route table, they share the same set of routing rules. 
# You don't need to create a separate route table unless you want different routing rules for each subnet.
# Since both subnets will route traffic to the Internet Gateway, both subnet-1 and subnet-2 will be considered public subnets (assuming the instances inside them have public IPs).
resource "aws_route_table_association" "subnets-route" {
  count  = var.subnets_public ? var.az_count : 0 
  subnet_id      = aws_subnet.my-subnets[count.index].id
  route_table_id = aws_route_table.route_table[0].id
}

# resource "aws_route_table_association" "subnets-route" {
#   count  = var.subnets_public ? var.az_count : 0 
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.route_table.id
# }

# resource "aws_route_table_association" "subnet-2-route" {
#   count  = var.subnets_public ? 1 : 0 
#   subnet_id      = aws_subnet.subnet-2.id
#   route_table_id = aws_route_table.route_table.id
# }