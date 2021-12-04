data "aws_vpc" "vpc_data" {
  filter {
    name = "tag:Name"
    values = [ "testing-vpc" ]
  }
}

data "aws_subnet" "subnet_data" {
  filter {
    name = "tag:Name"
    values = [ "testing-subnet" ]
  }
}

data "aws_internet_gateway" "internet_gateway_testing" {
  filter {
    name = "tag:Name"
    values = [ "internet_gateaway" ]
  }
}

resource "aws_security_group" "security_test_kubemaster" {
  name = "testing_environtment_sg"
  description = "testing environment"
  vpc_id = data.aws_vpc.vpc_data.id

  ingress {
    description      = "SSH Web"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-kubemaster-traffic"
  }
}

resource "aws_network_interface" "network-interface-kubemaster-testing" {
  subnet_id       = data.aws_subnet.subnet_data.id
  private_ips     = var.list_private_ips
  security_groups = [aws_security_group.security_test_kubemaster.id]
  
  tags = {
    "Name" = "network_interface_kubemaster_testing"
  }
}

resource "aws_instance" "testing-kubemaster" {
  count = var.instance_quantity
  ami = var.ami_code
  instance_type = var.type_instance
  availability_zone = var.region
  key_name = var.key_name
  #subnet_id = data.aws_subnet.subnet_data.id

  network_interface {
    network_interface_id = aws_network_interface.network-interface-kubemaster-testing.id
    device_index = 0
  }

  # root_block_device { 
  #   volume_type = "gp2"
  #   volume_size = 20
  # }
  
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo hostnamectl set-hostname ${var.dns}-${count.index}"
  #   ]
  # }

  tags = {
    Name = "kubemaster-${count.index}"
  }
}


# resource "aws_ebs_volume" "ebs_kubemaster" {
#   count = var.instance_quantity
#   availability_zone = var.region
#   size = 40
#   type = "gp2"

#   tags = {
#     Name =  "ebs_kubemaster-${count.index}"
#   }
# }

# resource "aws_volume_attachment" "attach_volume_instance" {
#   count = var.instance_quantity
#   device_name = "/dev/sda1"
#   volume_id = aws_ebs_volume.ebs_kubemaster[count.index].id
#   instance_id = aws_instance.testing-kubemaster[count.index].id
# }

resource "aws_eip" "machine-eip" {
  count = var.instance_quantity
  vpc = true
  network_interface = aws_network_interface.network-interface-kubemaster-testing.id
  associate_with_private_ip = var.list_eip[count.index]
  depends_on = [data.aws_internet_gateway.internet_gateway_testing]
}

resource "aws_eip_association" "eip_assoc_testing" {
  count = var.instance_quantity
  instance_id = aws_instance.testing-kubemaster[count.index].id
  allocation_id = aws_eip.machine-eip[count.index].id
}