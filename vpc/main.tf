
provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
allocation_id = aws_eip.nat.id
subnet_id = aws_subnet.public.id

  tags = {
    Name = "main-nat-gateway"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private" {
vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "private" {
subnet_id = aws_subnet.private.id
route_table_id = aws_route_table.private.id
}

# Network ACL for Public Subnet
resource "aws_network_acl" "public" {
vpc_id = aws_vpc.main.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name = "public-nacl"
  }
}

# Network ACL for Private Subnet
resource "aws_network_acl" "private" {
vpc_id = aws_vpc.main.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name = "private-nacl"
  }
}

# Network ACL Association for Public Subnet
resource "aws_network_acl_association" "public" {
subnet_id = aws_subnet.public.id
network_acl_id = aws_network_acl.public.id
}

# Network ACL Association for Private Subnet
resource "aws_network_acl_association" "private" {
subnet_id = aws_subnet.private.id
network_acl_id = aws_network_acl.private.id
}
