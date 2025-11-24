provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami           = "ami-0ecb62995f68bb549" # Amazon Linux 2 AMI
    instance_type = "t3.micro"

    tags = {
        Name = "ExampleInstance"
    }
  
}

resource "aws_instance" "this" {
  ami = "ami-0ecb62995f68bb549"
    instance_type = "t3.micro"
    tags = {
        Name = "MyFirstInstance"
    }
}







