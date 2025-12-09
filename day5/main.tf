provider "aws" {
  region = "ap-southeast-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name = "terraform-key-toan2002"
  public_key = file("terraform-key-toan2002.pub")
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr 
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg1" {
  name = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id = aws_vpc.myvpc.id

  ingress  {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress {
    description = "HTTPs"
    from_port = 443
    to_port = 443
    protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
}
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}


resource "aws_instance" "server" {
  ami                    = "ami-00d8fc944fb171e29"
  instance_type          = "t3.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("./terraform-key-toan2002")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "./app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo apt install -y python3-flask",

    <<EOF
sudo bash -c 'cat >/etc/systemd/system/flask.service <<EOFF
[Unit]
Description=Flask App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu
ExecStart=/usr/bin/python3 /home/ubuntu/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOFF'
EOF
    ,

    "sudo systemctl daemon-reload",
    "sudo systemctl enable flask",
    "sudo systemctl start flask"
  ]
}
}