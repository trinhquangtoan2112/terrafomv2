provider "aws"{
    region = "us-east-1"
    alias = "usEast1"
}

provider "aws" {
  region = "ap-southeast-1" 
  alias = "apSouth1"
}

resource "aws_instance" "example" {
  provider =  aws.apSouth1
  ami = var.ami_instance
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  
}
