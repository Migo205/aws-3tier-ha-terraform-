# Public subnet in AZ1 (for ALB and NAT Gateway)
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}

# Public subnet in AZ2 (for ALB and NAT Gateway)
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}

# Private subnet in AZ1 (for web servers and RDS)
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "private_subnet1"
  }
}

# Private subnet in AZ2 (for web servers and RDS)
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "private_subnet2"
  }
}

# Internet Gateway – allows public subnets to reach the internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

# Elastic IP for NAT Gateway in AZ1
resource "aws_eip" "eip_nat1" {
  domain = "vpc"

  tags = {
    Name = "eip-nat1"
  }
}

# Elastic IP for NAT Gateway in AZ2
resource "aws_eip" "eip_nat2" {
  domain = "vpc"

  tags = {
    Name = "eip-nat2"
  }
}

# NAT Gateway in public_subnet1 – allows private subnet1 outbound internet access
resource "aws_nat_gateway" "nat_gateway1" {
  allocation_id = aws_eip.eip_nat1.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "gw NAT1"
  }

  depends_on = [aws_internet_gateway.gw]
}

# NAT Gateway in public_subnet2 – allows private subnet2 outbound internet access
resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.eip_nat2.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = "gw NAT2"
  }

  depends_on = [aws_internet_gateway.gw]
}

# Public route table – routes all outbound traffic via Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Private route table for AZ1 – routes outbound traffic via NAT Gateway 1
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "private-rt-az1"
  }
}

# Private route table for AZ2 – routes outbound traffic via NAT Gateway 2
resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway2.id
  }

  tags = {
    Name = "private-rt-az2"
  }
}

# Associate public_subnet1 with public route table
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate public_subnet2 with public route table
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate private_subnet1 with its dedicated private route table
resource "aws_route_table_association" "p1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

# Associate private_subnet2 with its dedicated private route table
resource "aws_route_table_association" "p2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}