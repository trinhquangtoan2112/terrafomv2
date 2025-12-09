variable "ami_instance" {
  default = "ami-00d8fc944fb171e29"
  description = "ap south east asia instance"
  type = string
}

variable "instance_type" {
  default = "t3.micro"
  description = "instance_type for ec2"
  type = string
}

variable "subnet_id" {
  default = "subnet-042666fd6315577e4"
  description = "value for subnet id"
  type = string
}
