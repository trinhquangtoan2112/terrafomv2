provider "aws"{
    region = "us-east-1"
    alias = "usEast1"
}

provider "aws" {
  region = "ap-southeast-1" 
  alias = "apSouth1"
}


resource "aws_instance" "us1" {
    provider = aws.usEast1
     ami = var.ami_instance
    instance_type = "t3.micro"
    tags = {
        Name = "MyFirstInstanceUs"
    }
    
  
}

resource "aws_instance" "ap1" {
    provider = aws.apSouth1
     ami = "ami-00d8fc944fb171e29"
    instance_type = "t3.micro"
    tags = {
        Name = "MyFirstInstanceUs"
    }
  
}