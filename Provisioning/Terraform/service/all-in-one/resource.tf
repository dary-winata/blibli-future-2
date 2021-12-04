module "create-env" {
  source = "E:\\Pekerjaan\\file\\Blibli-Future2\\Provisioning\\Terraform\\module\\network"
}

module "instance-kubemaster" {
  source = "E:\\Pekerjaan\\file\\Blibli-Future2\\Provisioning\\Terraform\\module\\resource\\kubemaster"
  instance_quantity = 1
  key_name = "testing-env"
  ami_code = "ami-0adfdaea54d40922b"
  region = "ap-southeast-1a"
  index_interface = 0
  type_instance = "t2.micro"
  list_eip = [ "10.0.1.120", "10.0.1.121", "10.0.1.122", "10.0.1.123", "10.0.1.124" ]
  dns = "kubemaster"
  list_private_ips = [ "10.0.1.120", "10.0.1.121", "10.0.1.122", "10.0.1.123", "10.0.1.124" ]
}