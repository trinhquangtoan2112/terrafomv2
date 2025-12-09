terraform {
  backend "s3" {
    bucket = "terraform-storage-backend-211220023"
    key = "trinhtoan2112/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-locks-toan20022112"
  }
}