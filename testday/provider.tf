terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "5.11.0"
    }
  }
#   backend "s3" {
#      bucket = "terraform-storage-backend-211220023"
#     key = "trinhtoan2112/terraform.tfstate"
#     region = "ap-southeast-1"
#   }
}

provider "aws" {
  region = "ap-southeast-1"
  alias = "southeast1"
}


