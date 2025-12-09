provider "aws" {
   region = "ap-southeast-1"
   alias = "apSouthEast1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_instance = "ami-00d8fc944fb171e29"
  instance_type = "t3.small"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  
}