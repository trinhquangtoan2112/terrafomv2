provider "aws" {
  region = "ap-southeast-1"
}

provider "vault" {
  address = "http://13.229.156.13:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
        role_id = "b35f2d3b-3cfc-c7bb-6211-8b36c64d4d8f"
        secret_id = "86e9d0fb-f354-f4a9-d391-07bdf8b42af3"
    }
  }
}

data "vault_kv_secret_v2" "userdata" {
  mount = "kv123"
  name = "test"
}


resource "aws_instance" "testsss" {
  ami = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"
 key_name = null 
  tags = {
    Name = data.vault_kv_secret_v2.userdata.data["ssss"]
    secret = data.vault_kv_secret_v2.userdata.data["ssss"]

  }
}