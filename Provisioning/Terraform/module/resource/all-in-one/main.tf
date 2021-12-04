resource "aws_instance" "testing-centos" {
  count = var.instance_quantity
  ami = var.ami_instance
  instance_type = var.type_instance
  availability_zone = "ap-southeast-1a"
  key_name = "testing-env"

  network_interface {
    network_interface_id = aws_network_interface.network-interface-testing.id 
    device_index = 0
  }

  tags = {
    Name = "instance"
  }
}

resource "aws_eip" "machine-eip" {
  count = var.instance_quantity
  vpc = true
  network_interface = aws_network_interface.network-interface-testing.id
  associate_with_private_ip = "10.0.1.125"
  depends_on = [aws_internet_gateway.internet_gateaway] 
}

resource "aws_eip_association" "eip_assoc-1" {
  instance_id = aws_instance.testing-centos-1.id
  allocation_id = aws_eip.machine-1-eip.id
}