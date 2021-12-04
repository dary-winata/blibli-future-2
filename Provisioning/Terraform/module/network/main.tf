resource "aws_vpc" "testing-vpc" {
  cidr_block = "10.0.1.0/24"
  assign_generated_ipv6_cidr_block = true
  
  tags = {
    Name = "testing-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateaway" {
    vpc_id = aws_vpc.testing-vpc.id

    tags = {
      Name = "internet_gateaway"
    }
}

resource "aws_egress_only_internet_gateway" "internet_gateway_egress" {
  vpc_id = aws_vpc.testing-vpc.id
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.testing-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet_gateaway.id
  }
  
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.internet_gateway_egress.id
  }
  tags = {
    Name = "testing-route"
  }
}

resource "aws_subnet" "subnet_env" {
  vpc_id = aws_vpc.testing-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "testing-subnet"
  }
}