provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "toan2002" {
  instance_type = "t3.micro"
  ami           = "ami-00d8fc944fb171e29"
  subnet_id = "subnet-042666fd6315577e4"
}

# resource "aws_s3_bucket" "s3bucket" {
#     bucket = "toan2002-bucketqwassa"
#     region = "ap-southeast-1"
#     versioning {
#         enabled = true
#     }

# }

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks-toan20022112"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}