# resource "aws_vpc" "testing-vpc" {
#   cidr_block = "10.0.1.0/24"
#   assign_generated_ipv6_cidr_block = true
  
#   tags = {
#     Name = "testing"  
#   }
# }

# resource "aws_internet_gateway" "internet_gateaway" {
#     vpc_id = aws_vpc.testing-vpc.id
#   }

# resource "aws_egress_only_internet_gateway" "internet_gateway_egress" {
#   vpc_id = aws_vpc.testing-vpc.id
# }

# resource "aws_route_table" "route" {
#   vpc_id = aws_vpc.testing-vpc.id

#   route {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = aws_internet_gateway.internet_gateaway.id
#   }
  
#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.internet_gateway_egress.id
#   }
#   tags = {
#     Name = "testing-route"
#   }
# }

# resource "aws_subnet" "subnet_env" {
#   vpc_id = aws_vpc.testing-vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "ap-southeast-1a"

#   tags = {
#     Name = "testing-subnet"
#   }
# }

# resource "aws_route_table_association" "route_table_assoc" {
#   subnet_id = aws_subnet.subnet_env.id
#   route_table_id = aws_route_table.route.id
# }

# resource "aws_security_group" "security_webserver_traffic" {
#   name = "webserver_traffic"
#   description = "webserver inbound traffict"
#   vpc_id = aws_vpc.testing-vpc.id

#   ingress {
#     description      = "HTTPS Webserver"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
  
#   ingress {
#     description      = "HTTP Webserver"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     description      = "SSH Web"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "security_webserver_traffic"
#   }
# }

resource "aws_network_interface" "network-interface-testing" {
  subnet_id       = aws_subnet.subnet_env.id
  private_ips     = ["10.0.1.125"]
  security_groups = [aws_security_group.security_webserver_traffic.id]
}

resource "aws_instance" "testing-centos-1" {
  ami = "ami-0d6ba217f554f6137"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-1a"
  key_name = "testing-env"

  network_interface {
    network_interface_id = aws_network_interface.network-interface-testing.id 
    device_index = 0
  }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install nginx -y
                sudo systemctl start nginx
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

  tags = {
    Name = "web-server"
  }
}

resource "aws_eip" "machine-1-eip" {
  vpc = true
  network_interface = aws_network_interface.network-interface-testing.id
  associate_with_private_ip = "10.0.1.125"
  depends_on = [aws_internet_gateway.internet_gateaway] 
}

resource "aws_eip_association" "eip_assoc-1" {
  instance_id = aws_instance.testing-centos-1.id
  allocation_id = aws_eip.machine-1-eip.id
}