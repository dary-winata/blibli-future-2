variable "instance_quantity" {
  type = number
  description = "value for set quantity of instance"
  default = 0
}

variable "key_name" {
  type = string
  description = "value for key name"
  default = "testing-env"
}

variable "ami_code" {
  type = string
  description = "value for ami"
  default = "ami-0d6ba217f554f6137"
}

variable "region" {
  type = string
  description = "value for region"
  default = "ap-southeast-1a"
}

variable "index_interface" {
    type = number
    description = "value for index interface that wanted to use"
}

variable "type_instance" {
  type = string
  description = "value for instance type"
  default = "t2.micro"
}

variable "list_eip" {
  type = list(string)
  description = "value for ip in eip for every instance"
  default = [ "" ]
}

variable "dns" {
  type = string
  description = "value public dns"
  default = "kubemaster"
}

variable "start_form_index" {
  type = number
  default = 0
}

variable "list_private_ips" {
  type = list(string)
  description = "list private ips for private ip in cluster"
  default = [ "10.0.1.120", "10.0.1.121", "10.0.1.122", "10.0.1.123", "10.0.1.124" ]
}