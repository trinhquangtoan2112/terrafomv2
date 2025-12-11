resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet" {
  count = 4
  vpc_id = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(aws_vpc.vpc1.cidr_block,  8, count.index)
  map_public_ip_on_launch = count.index == 0 ? true : false
}


resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.vpc1.id
}
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
    tags = {
        Name = "rt1"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig1.id
    }

}


resource "aws_route_table_association" "rta" {
  count = 1
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_security_group" "sg1" {
    name = "allow_ssh_http_https"
    description = "Allow SSH, HTTP and HTTPS inbound traffic"
    vpc_id = aws_vpc.vpc1.id
    ingress{
        description = "SSH"
        from_port = 22
        to_port = 22
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
  key_name      = "A4L"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.subnet[0].id
}

resource "aws_lb" "load-balancer1" {
  name = "load-balancer1"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg1.id]
  subnets = [aws_subnet.subnet[0].id]
  
}

resource "aws_lb_target_group" "lbtg1" {
  name = "MyTg"
  port = 80 
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc1.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
  stickiness {
    enabled = true
    type = "lb_cookie"
     cookie_duration = 86400 
  }  
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.lbtg1.arn
  target_id = aws_instance.server.id
  port = 80
}

resource "aws_lb_listener" "listerner1" {
  load_balancer_arn = aws_lb.load-balancer1.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lbtg1.arn
  }
}


output "loadBalancerDns" {
  value = aws_lb.load-balancer1.dns_name
}