variable "instance_quantity" {
  type = number
  description = "value for set quantity of instance"
  default = 0
}

variable "ami_instance" {
  type = string
  description = "value for instance linux distro"
  default = "ami-0d6ba217f554f6137"
}

variable "type_instance" {
  type = string
  description = "value for instance type"
  default = "t2.micro"
}